//   EventViewModel.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 4:36 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

/// `GameViewModel` manages the state and operations related to game data, particularly fetching 
/// and displaying filtered game events from an external API.

class GameViewModel: ObservableObject {
   // Published array of filtered events based on specific criteria.
   @Published var filteredEvents: [gameEvent] = []
   @Published var allEvents: [gameEvent] = []
   @Published var teamPlaying: String = "New York Yankees"
   @Published  var lastPlayHist: [String] = []
   @Published var subStrike = 0
   @Published var foulStrike2: Bool = false
   @Published var startDate: String = ""
   @Published var startTime: String = ""
   @Published var isToday = false
//   private var isToday: Bool = false

   func loadAllGames() {
	  guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard") else { return }
	  URLSession.shared.dataTask(with: url) { data, response, error in
		 guard let data = data, error == nil else {
			print("Network error: \(error?.localizedDescription ?? "No error description")")
			return
		 }
		 do {
			let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
			DispatchQueue.main.async { [self] in
			   self.allEvents = decodedResponse.events.map { event in
				  let situation = event.competitions[0].situation
				  let homeTeam = event.competitions[0].competitors[0]
				  let awayTeam = event.competitions[0].competitors[1]
				  let inningTxt = event.competitions[0].status.type.detail
				  let startTime = convertTimeTo12HourFormat(dateString: event.date, DST: true)

				  let lastPlay = situation?.lastPlay?.text
				  self.extractDateAndTime(from: event.date)

				  if self.lastPlayHist.last != lastPlay {
					 self.lastPlayHist.append(lastPlay ?? "")
				  }

				  if let situationStrikes = situation?.strikes {
					 if situationStrikes < 2 {
						self.subStrike = 0
						self.foulStrike2 = false
					 } else {
						if let thisLastPlay = lastPlay {
						   if thisLastPlay.lowercased().contains("strike 2 foul") && situationStrikes == 2 {
							  if !self.foulStrike2 {
								 self.foulStrike2 = true
							  } else {
								 self.subStrike += 1
							  }
						   } else {
							  self.foulStrike2 = false
							  self.subStrike = 0
						   }
						} else {
						   self.foulStrike2 = false
						}
					 }
				  } else {
					 self.foulStrike2 = false
				  }

				  // Determine if the game is final and adjust the score string
				  let isFinal = inningTxt.contains("Final")
				  let homeScore = homeTeam.score ?? "0"
				  let visitScore = awayTeam.score ?? "0"
				  let scoreString = isFinal ? "\(visitScore) / \(homeScore) - F" : "\(visitScore) / \(homeScore)"

				  return gameEvent(
					 title: event.name,
					 shortTitle: event.shortName,
					 home: homeTeam.team.name,
					 visitors: awayTeam.team.name,
					 homeRecord: homeTeam.records.first?.summary ?? "0-0",
					 visitorRecord: awayTeam.records.first?.summary ?? "0-0",
					 inning: event.status.period,
					 homeScore: homeScore,
					 visitScore: visitScore,
					 homeColor: homeTeam.team.color,
					 homeAltColor: homeTeam.team.alternateColor,
					 visitorColor: awayTeam.team.color,
					 visitorAltColor: awayTeam.team.alternateColor,
					 on1: situation?.onFirst ?? false,
					 on2: situation?.onSecond ?? false,
					 on3: situation?.onThird ?? false,
					 lastPlay: situation?.lastPlay?.text ?? inningTxt,
					 balls: situation?.balls ?? 0,
					 strikes: situation?.strikes ?? 0,
					 outs: situation?.outs ?? 0,
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


   func loadData() {
	  guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard") else { return }
	  URLSession.shared.dataTask(with: url) { data, response, error in
		 guard let data = data, error == nil else {
			print("Network error: \(error?.localizedDescription ?? "No error description")")
			return
		 }
		 do {
			// MARK:  JSON decoding into APIResponse structure.
			let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
			// Switches the execution context to the main thread.
			DispatchQueue.main.async { [self] in
			   self.filteredEvents = decodedResponse.events.filter { $0.name.contains(teamPlaying) }.map { event in

				  // MARK: event tree vars
				  let situation = event.competitions[0].situation
				  let homeTeam = event.competitions[0].competitors[0]
				  let awayTeam = event.competitions[0].competitors[1]
				  let inningTxt = event.competitions[0].status.type.detail

				  // MARK: situation vars
				  let lastPlay = situation?.lastPlay?.text

				  self.extractDateAndTime(from: event.date)

				  // MARK: update lastPlay stack
				  if self.lastPlayHist.last != lastPlay { // don't add it again if it's the same play
					 self.lastPlayHist.append(lastPlay ?? "")
				  }

				  // MARK: subStrike calculation

				  if let situationStrikes = situation?.strikes {
					 if situationStrikes < 2 {
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
								self.subStrike = 0 // remove this line if issues
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

				  startTime = convertTimeTo12HourFormatOrig(time24: startTime, DST: true)

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

   func convertTimeTo12HourFormat(dateString: String, DST: Bool) -> String {
	  // Create a DateFormatter to parse the input date-time string
	  let inputFormatter = DateFormatter()
	  inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
	  inputFormatter.timeZone = TimeZone(abbreviation: "UTC") // Assume the input is in UTC
	  inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POSIX to ensure the format is interpreted correctly

	  // Parse the input date-time string to a Date object
	  guard let date = inputFormatter.date(from: dateString) else {
		 return "Invalid time" // Return an error message or handle appropriately
	  }

	  // If DST is true, add one hour to the date
	  let adjustedDate = DST ? date.addingTimeInterval(3600) : date

	  // Create another DateFormatter to format the Date object to 12-hour time format with AM/PM
	  let outputFormatter = DateFormatter()
	  outputFormatter.dateFormat = "h:mm a"
	  outputFormatter.timeZone = TimeZone.current // Set to user's current timezone
	  outputFormatter.locale = Locale.current // Adjust to the current locale for correct AM/PM

	  // Convert the adjusted Date object to the desired time format string
	  let time12 = outputFormatter.string(from: adjustedDate)

	  return time12
   }



   func convertTimeTo12HourFormatOrig(time24: String, DST: Bool) -> String {
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

	  // Check if the the date is today and if so, the game is over so display FINAL
	  // isToday is utilized in the ScoreCardView to display Final vs. Starting at: ...
	  let calendar = Calendar.current
	  isToday = calendar.isDateInToday(adjustedDate)

	  return time12
   }
}


