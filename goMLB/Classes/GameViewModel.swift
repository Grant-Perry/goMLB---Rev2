//   EventViewModel.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 4:36 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

/// ViewModel responsible for loading and managing baseball event data.
/// @Observable
class GameViewModel: ObservableObject {
	// Published array of filtered events based on specific criteria.
	@Published var filteredEvents: [gameEvent] = []
	@Published var teamPlaying: String = "New York Yankees"
	@Published  var lastPlayHist: [String] = []
	@Published var subStrike = 0
	@Published var foulStrike2: Bool = false
	@Published var startDate: String = ""
	@Published var startTime: String = ""

	struct gameEvent {
		var ID: UUID = UUID()
		var title: String        // Full title of the event.
		var shortTitle: String   // Shortened title of the event.
		var home: String         // Home team name.
		var visitors: String     // Visiting team name.
		var homeRecord: String  //  Home team's season record
		var visitorRecord: String  // Visitor's season record
		var inning: Int          // Current inning number.
		var homeScore: String    // Home team's current score.
		var visitScore: String   // Visitor team's current score.
		var homeColor: String 	// home colors
		var visitorColor: String 	// visitors colors
		var on1: Bool            // Runner on first base.
		var on2: Bool            // Runner on second base.
		var on3: Bool            // Runner on third base.
		var lastPlay: String?    // Description of the last play.
		var balls: Int?          // Current ball count.
		var strikes: Int?        // Current strike count.
		var outs: Int?           // Current out count.
		var homeLogo: String
		var visitorLogo: String
		var inningTxt: String
		var thisSubStrike: Int
		var thisCalledStrike2: Bool
		var startDate: String
		var startTime: String
		var atBat: String
		var atBatPic: String
		var atBatSummary: String
	}

	func updateTeamPlaying(with team: String) {
		teamPlaying = team // Update the teamPlaying with the new team
		loadData() // Reload data based on the new team
	}

	private func extractDateAndTime(from dateString: String) { // split up the date string
		let parts = dateString.split(separator: "T")
		if parts.count == 2 {
			self.startDate = String(parts[0])
			self.startTime = String(parts[1].dropLast())  // Removes the 'Z' if present
		}
	}

	/// Loads baseball event data from an API, filters it, and updates the view model.
	func loadData() {

		//		let eventViewModel: EventViewModel = EventViewModel

		//  MARK: Team Playing
		//	  let teamPlaying = "Dodgers"


		guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard") else { return }

		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
				print("Network error: \(error?.localizedDescription ?? "No error description")")
				return
			}

			do {
				// Decoding JSON into APIResponse structure.
				let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
				// Switches the execution context to the main thread.
				DispatchQueue.main.async { [self] in

					// This line ensures that the UI update is performed on the main thread, which is crucial for any UI
					// changes in iOS development to avoid UI freezing or crashes.

					// teamPlaying holds the value to filter the list of events to include to only those where the name contains the value of teamPlaying.
					// Then it maps the results to a new structure.

					self.filteredEvents = decodedResponse.events.filter { $0.name.contains(teamPlaying) }.map { event in

						// Filtering and Mapping: The filter method screens the events based on the condition that their names contain teamPlaying.
						// This is followed by the map method, which transforms each filtered event into an EventDisplay object structured to
						// fit the UI's needs. This includes extracting and simplifying data from nested structures (like competitors and situations).

						// Accesses the current situation details of the first competition in each event.
						let situation = event.competitions[0].situation  // holds the entire "situation" JSON tree
						let homeTeam = event.competitions[0].competitors[0] // holds the entire home "competitors" JSON tree
						let awayTeam = event.competitions[0].competitors[1] // holds the entire visitor "competitors" JSON tree
						let lastPlay = situation?.lastPlay?.text
						let inningTxt = event.competitions[0].status.type.detail
						self.extractDateAndTime(from: event.date)
						let atBat = situation?.batter?.athlete.shortName ?? ""
						let atBatPic = situation?.batter?.athlete.headshot ?? ""
//						let atBatSummary = situation?.batter?.athlete.summary ?? ""

						// MARK: update lastPlay stack
						if self.lastPlayHist.last != lastPlay { // don't add it again if it's the same play
							self.lastPlayHist.append(lastPlay ?? "")
						}
						//				  print("strikeStack Prior: \(subStrike)")

						// MARK: subStrike calculation
						if situation?.strikes ?? 0 == 0 { // clean up/reset subStrike if strike count back to 0
							self.subStrike = 0
							self.foulStrike2 = false
						} else {
							if let lowerCasedLastPlay = lastPlay?.lowercased() {
								if lowerCasedLastPlay.contains("strike 2 foul") && situation?.strikes ?? 0 == 2 { // this is a strike 2 foul

									// was this strike 2 because of the foul? If so, don't increment subStrike but then set foulStrike2 state to true
									if self.foulStrike2 {
										self.subStrike += 1
									}
									self.foulStrike2 = true
								}
							}
						}
						//				  print("strikeStack After: \(subStrike)")
						startTime = convertTimeTo12HourFormat(time24: startTime, DST: true)
						//				  print("startDate: \(startDate) - startTime: \(startTime)")



						return gameEvent(
							title: event.name,  // Sets the full title of the event.
							shortTitle: event.shortName,  // Sets a shorter title for the event.
							home: homeTeam.team.name,  // Sets the home team name using the first competitor's team name.
							visitors: awayTeam.team.name,  // Sets the visiting team name using the second competitor's team name.
							homeRecord: homeTeam.records.first?.summary ?? "0-0", // set the home season record
							visitorRecord: awayTeam.records.first?.summary ?? "0-0", // set the away season record
							inning: event.status.period,  // Sets the current inning number from the event status.
							homeScore: homeTeam.score ?? "0",  // Sets the home team's score, defaulting to "0" if null.
							visitScore: awayTeam.score ?? "0",  // Sets the visiting team's score, defaulting to "0" if null.
							homeColor: homeTeam.team.alternateColor,
							visitorColor: awayTeam.team.alternateColor,
							on1: situation?.onFirst ?? false,  // Indicates if there is a runner on first base, defaulting to false if null.
							on2: situation?.onSecond ?? false,  // Indicates if there is a runner on second base, defaulting to false if null.
							on3: situation?.onThird ?? false,  // Indicates if there is a runner on third base, defaulting to false if null.
							lastPlay: situation?.lastPlay?.text ?? inningTxt,  // Sets the text of the last play, defaulting to "" if null.
							balls: situation?.balls ?? 0,  // Sets the current number of balls, defaulting to 0 if null.
							strikes: situation?.strikes ?? 0,  // Sets the current number of strikes, defaulting to 0 if null.
							outs: situation?.outs ?? 0,  // Sets the current number of outs, defaulting to 0 if null.
							homeLogo: homeTeam.team.logo,
							visitorLogo: awayTeam.team.logo,
							inningTxt: inningTxt,
							thisSubStrike: subStrike,
							thisCalledStrike2: foulStrike2,
							startDate: startDate,
							startTime: startTime,
							atBat: situation?.batter?.athlete.shortName ?? "",
							atBatPic: situation?.batter?.athlete.headshot ?? "",
							atBatSummary: situation?.batter?.athlete.summary ?? ""
						)
					}
				}
			} catch {
				print("Error decoding JSON: \(error)")
			}
		}.resume()
	}
}

// MARK:  Helpers

extension GameViewModel {
	func convertTimeTo12HourFormat(time24: String, DST: Bool) -> String {
		// Create a DateFormatter to parse the input time in 24-hour format
		let inputFormatter = DateFormatter()
		inputFormatter.dateFormat = "HH:mm"
		inputFormatter.timeZone = TimeZone(abbreviation: "UTC") // Assume the input is in UTC
		inputFormatter.locale = Locale(identifier: "en_US_POSIX")  // Use POSIX to ensure the format is interpreted correctly

		// Parse the input time string to a Date object
		guard let date = inputFormatter.date(from: time24) else {
			return "Invalid time"  // Return an error message or handle appropriately
		}

		// If DST is true, add one hour to the date
		let adjustedDate = DST ? date.addingTimeInterval(3600) : date

		// Create another DateFormatter to format the Date object to 12-hour time format with AM/PM
		let outputFormatter = DateFormatter()
		outputFormatter.dateFormat = "h:mm a"
		outputFormatter.timeZone = TimeZone.current  // Set to user's current timezone
		outputFormatter.locale = Locale.current  // Adjust to the current locale for correct AM/PM

		// Convert the adjusted Date object to the desired time format string
		let time12 = outputFormatter.string(from: adjustedDate)
		return time12
	}
}


