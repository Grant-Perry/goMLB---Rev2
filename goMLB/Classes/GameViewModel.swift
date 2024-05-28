//   GameViewModel.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 4:36 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
import Foundation

class GameViewModel: ObservableObject {
   @Published var filteredEvents: [gameEvent] = []
   @Published var allEvents: [gameEvent] = []
   @Published var teamPlaying: String = "New York Yankees"
   @Published var lastPlayHist: [String] = []
   @Published var subStrike = 0
   @Published var foulStrike2: Bool = false
   @Published var startDate: String = ""
   @Published var startTime: String = ""
   @Published var isToday = false
   @Published var holdLastPlay = ""

   func loadAllGames(showLiveAction: Bool, completion: (() -> Void)? = nil) {
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
				  let competition = event.competitions[0]
				  let homeTeam = competition.competitors[0]
				  let awayTeam = competition.competitors[1]
				  let situation = competition.situation
				  let inningTxt = competition.status.type.detail
				  let startTime = convertTo12HourFormat(from: event.date, DST: false)
				  let lastPlay = situation?.lastPlay?.text

				  self.extractDateAndTime(from: event.date)

				  if let thisLastPlay = self.lastPlayHist.last, !thisLastPlay.isEmpty {
					 self.lastPlayHist.append(thisLastPlay)
					 holdLastPlay = thisLastPlay
				  }

				  if let situationStrikes = situation?.strikes, situationStrikes == 2 {
					 foulStrike2 = true
				  }

				  return gameEvent(
					 ID: UUID(),
					 title: event.name,
					 shortTitle: event.shortName,
					 home: homeTeam.team.name,
					 visitors: awayTeam.team.name,
					 homeRecord: homeTeam.records.first?.summary ?? "",
					 visitorRecord: awayTeam.records.first?.summary ?? "",
					 inning: event.status.period,
					 homeScore: homeTeam.score ?? "0",
					 visitScore: awayTeam.score ?? "0",
					 homeColor: homeTeam.team.color,
					 homeAltColor: homeTeam.team.alternateColor,
					 visitorColor: awayTeam.team.color,
					 visitorAltColor: awayTeam.team.alternateColor,
					 on1: situation?.onFirst ?? false,
					 on2: situation?.onSecond ?? false,
					 on3: situation?.onThird ?? false,
					 lastPlay: lastPlay,
					 balls: situation?.balls,
					 strikes: situation?.strikes,
					 outs: situation?.outs,
					 homeLogo: homeTeam.team.logo,
					 visitorLogo: awayTeam.team.logo,
					 inningTxt: inningTxt,
					 thisSubStrike: subStrike,
					 thisCalledStrike2: foulStrike2,
					 startDate: self.startDate,
					 startTime: startTime,
					 atBat: situation?.batter?.athlete.shortName ?? "",
					 atBatPic: situation?.batter?.athlete.headshot ?? "",
					 atBatSummary: situation?.batter?.athlete.summary ?? ""
				  )
			   }
			   if let completion = completion {
				  completion()
			   }
			}
		 } catch {
			print("Decoding error: \(error.localizedDescription)")
		 }
	  }.resume()
   }

   func updateTeamPlaying(with team: String) {
	  teamPlaying = team
	  filteredEvents = allEvents.filter { $0.visitors.contains(teamPlaying) || $0.home.contains(teamPlaying) }
   }

   private func extractDateAndTime(from dateString: String) {
	  let parts = dateString.split(separator: "T")
	  if parts.count == 2 {
		 self.startDate = String(parts[0])
		 self.startTime = String(parts[1].dropLast())
	  }
   }

   func convertTo12HourFormat(from dateString: String, DST: Bool) -> String {
	  let inputFormatter = DateFormatter()
	  inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
	  inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
	  inputFormatter.locale = Locale(identifier: "en_US_POSIX")

	  guard let date = inputFormatter.date(from: dateString) else {
		 return "Invalid time"
	  }

	  // Adjust for DST if necessary
	  let adjustedDate = DST ? date.addingTimeInterval(3600) : date

	  let outputFormatter = DateFormatter()
	  outputFormatter.dateFormat = "h:mm a"
	  outputFormatter.timeZone = TimeZone.current
	  outputFormatter.locale = Locale.current

	  return outputFormatter.string(from: adjustedDate)
   }
}











