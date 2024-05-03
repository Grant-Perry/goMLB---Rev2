//   EventViewModel.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 4:36 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

/// `GameViewModel` manages the state and operations related to game data, particularly fetching and displaying filtered game events from an external API.
class GameViewModel: ObservableObject {
   // Published array of filtered events based on specific criteria.
   @Published var filteredEvents: [gameEvent] = []
   @Published var teamPlaying: String = "New York Yankees"
   @Published  var lastPlayHist: [String] = []
   @Published var subStrike = 0
   @Published var foulStrike2: Bool = false
   @Published var startDate: String = ""
   @Published var startTime: String = ""

   /// Loads baseball event data from an API, filters it, and updates the view model.
   func loadData() {
	  guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard") else { return }
	  URLSession.shared.dataTask(with: url) { data, response, error in
		 guard let data = data, error == nil else {
			print("Network error: \(error?.localizedDescription ?? "No error description")")
			return
		 }
		 do {
			// MARK:  Decoding JSON into APIResponse structure.
			let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
			// Switches the execution context to the main thread.
			DispatchQueue.main.async { [self] in
			   self.filteredEvents = decodedResponse.events.filter { $0.name.contains(teamPlaying) }.map { event in

				  // Filtering and Mapping: The filter method screens the events based on the condition that their names contain teamPlaying.
				  // This is followed by the map method, it transforms each filtered event into an EventDisplay object structured to
				  // fit the UI's needs. This includes extracting and simplifying data from nested structures (like competitors and situations).

				  // Accesses the current situation details of the first competition in each event.
				  // MARK: event tree vars
				  let situation = event.competitions[0].situation  // holds the entire "situation" JSON tree
				  let homeTeam = event.competitions[0].competitors[0] // holds the entire home "competitors" JSON tree
				  let awayTeam = event.competitions[0].competitors[1] // holds the entire visitor "competitors" JSON tree
				  let inningTxt = event.competitions[0].status.type.detail

				  // MARK: situation vars
				  let lastPlay = situation?.lastPlay?.text
				  let atBat = situation?.batter?.athlete.shortName ?? ""
				  let atBatPic = situation?.batter?.athlete.headshot ?? ""
				  let atBatSummary = situation?.batter?.athlete.summary ?? ""

				  self.extractDateAndTime(from: event.date)

				  // MARK: update lastPlay stack
				  if self.lastPlayHist.last != lastPlay { // don't add it again if it's the same play
					 self.lastPlayHist.append(lastPlay ?? "")
				  }

				  // MARK: subStrike calculation

				  if let situationStrikes = situation?.strikes {
					 if situationStrikes == 0 {
						// Reset when strikes are cleared (new batter or other event)
						self.subStrike = 0
						self.foulStrike2 = false
					 } else {
						if let thisLastPlay = lastPlay {
						   if thisLastPlay.lowercased().contains("strike 2 foul") && situationStrikes == 2 {
							  // Check if this is the first "strike 2 foul" after the last reset
							  if !self.foulStrike2 {
								 self.foulStrike2 = true  // Indicate that a "strike 2 foul" has occurred
							  } else {
								 // If already marked as "strike 2 foul" and it happens again, increment subStrike
								 self.subStrike += 1
							  }
						   } else {
							  // If the current play is not a "strike 2 foul" or strikes aren't exactly 2, reset foulStrike2
							  self.foulStrike2 = false
						   }
						} else {
						   // Handle the case where lastPlay is nil
						   self.foulStrike2 = false
						}
					 }
				  } else {
					 // Handle the case where strikes information is nil
					 self.foulStrike2 = false
				  }



//				  if situation?.strikes ?? 0 == 0 { // clean up/reset subStrike if strike count back to 0
//					 self.subStrike = 0
//					 self.foulStrike2 = false
//				  } else {
//					 if let thisLastPlay = lastPlay, let situationStrikes = situation?.strikes {
//						// Check if the play was a "strike 2 foul" and the strike count is exactly 2
//						if thisLastPlay.lowercased().contains("strike 2 foul") && situationStrikes == 2 {
//
//						   // Set foulStrike2 to true to indicate that this was a strike due to a foul
//						   self.foulStrike2 = true
//
//						   // Only increment subStrike if foulStrike2 was already true,
//						   // meaning it has been previously set in another play
//						   if self.foulStrike2 {
//							  self.subStrike += 1
//						   }
//						} else {
//						   // If not a "strike 2 foul" or strikes aren't 2, ensure foulStrike2 is reset
//						   self.foulStrike2 = false
//						}
//					 } else {
//						// Handle the case where lastPlay or strikes is nil
//						self.foulStrike2 = false
//					 }
//				  }
				  startTime = convertTimeTo12HourFormat(time24: startTime, DST: true)

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
					 homeColor: homeTeam.team.color,
					 homeAltColor: homeTeam.team.alternateColor,
					 visitorColor: awayTeam.team.color,
					 visitorAltColor: awayTeam.team.alternateColor,
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


