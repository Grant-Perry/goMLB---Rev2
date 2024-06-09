//   GameViewModel.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 4:36 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

// GameViewModel.swift
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
   @Published var previousLastPlay = ""
   var isDebuggingEnabled = false // true to use local file

   // Published properties for UI elements
   @Published var logoWidth = 90.0
   @Published var teamSize = 16.0
   @Published var teamScoreSize = 25.0


   func loadAllGames(showLiveAction: Bool, completion: (() -> Void)? = nil) {
	  if isDebuggingEnabled {
		 if let path = Bundle.main.path(forResource: "gpLive", ofType: "json") {
			let url = URL(fileURLWithPath: path)
			if let data = try? Data(contentsOf: url) {
			   processGameData(data: data, showLiveAction: showLiveAction, completion: completion)
			}
		 }
	  } else {
		 guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard") else { return }
		 URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
			   print("Network error: \(error?.localizedDescription ?? "No error description")")
			   return
			}
			self.processGameData(data: data, showLiveAction: showLiveAction, completion: completion)
		 }.resume()
	  }
   }

   private func processGameData(data: Data, showLiveAction: Bool, completion: (() -> Void)? = nil) {
	  do {
		 if let jsonString = String(data: data, encoding: .utf8) {
//			print("Raw JSON Response: \(jsonString)")
		 }
		 let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
		 DispatchQueue.main.async { [self] in
			self.allEvents = decodedResponse.events.map { event in
			   createGameEvent(from: event)
			}

			if showLiveAction {
			   self.filteredEvents = self.allEvents.filter { !($0.inningTxt.contains("Final") || $0.inningTxt.contains("Scheduled")) }
			} else {
			   self.filteredEvents = self.allEvents.filter { $0.visitors.contains(teamPlaying) || $0.home.contains(teamPlaying) }
			}

			completion?()
		 }
	  } catch {
		 print("Error decoding JSON: \(error)")
	  }
   }

   func updateTeamPlaying(with teamName: String) {
	  teamPlaying = teamName
	  filteredEvents = allEvents.filter { $0.visitors.contains(teamPlaying) || $0.home.contains(teamPlaying) }
   }

   // Helper function to create gameEvent
   private func createGameEvent(from event: APIResponse.Event) -> gameEvent {
	  let competition = event.competitions[0]
	  let homeTeam = competition.competitors[0]
	  let awayTeam = competition.competitors[1]
	  let inningTxt = competition.status.type.detail
	  let startTime = convertTo12HourFormat(from: event.date, DST: false)

	  var lastPlay = competition.situation?.lastPlay?.text
	  self.extractDateAndTime(from: event.date)

	  // Update lastPlay to inningTxt if nil or empty
	  if lastPlay == nil {
		 lastPlay = inningTxt
	  }

	  if let thisLastPlay = self.lastPlayHist.last, !thisLastPlay.isEmpty {
		 self.lastPlayHist.append(thisLastPlay)
		 previousLastPlay = thisLastPlay
	  }

	  if let situationStrikes = competition.situation?.strikes {
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

	  // Simplified property assignments
	  let title = event.name
	  let shortTitle = event.shortName
	  let homeTeamName = homeTeam.team.name
	  let awayTeamName = awayTeam.team.name
	  let homeRecord = homeTeam.records?.first?.summary ?? "0-0"
	  let visitorRecord = awayTeam.records?.first?.summary ?? "0-0"
	  let inning = event.status.period ?? 0
	  let homeScore = homeTeam.score ?? "0"
	  let visitScore = awayTeam.score ?? "0"
	  let homeColor = homeTeam.team.color ?? "#C4CED3"
	  let homeAltColor = homeTeam.team.alternateColor ?? "#C4CED3"
	  let visitorColor = awayTeam.team.color ?? "#C4CED3"
	  let visitorAltColor = awayTeam.team.alternateColor ?? "#C4CED3"
	  let on1 = competition.situation?.onFirst ?? false
	  let on2 = competition.situation?.onSecond ?? false
	  let on3 = competition.situation?.onThird ?? false
	  let balls = competition.situation?.balls ?? 0
	  let strikes = competition.situation?.strikes ?? 0
	  let outs = competition.situation?.outs ?? 0
	  let homeLogo = homeTeam.team.logo ?? "N/A"
	  let visitorLogo = awayTeam.team.logo ?? "N/A"

	  // Additional variables for batter info, extracted for clarity
	  let batterName = competition.situation?.batter?.athlete.shortName ?? ""
	  let batterPic = competition.situation?.batter?.athlete.headshot ?? ""
	  let batterSummary = competition.situation?.batter?.athlete.summary // Leave as optional

	  // Get home and away statistics arrays, with default values for safety
	  let homeStats: [APIResponse.Event.Competition.Competitor.Statistic] = homeTeam.statistics
	  let awayStats: [APIResponse.Event.Competition.Competitor.Statistic] = awayTeam.statistics

	  // Using helper functions for stats to improve readability
	  let batterStats = getBatterStats(from: homeStats)
	  let batterLine = getBatterLine(from: homeTeam)
	  let visitorRuns = getVisitorRuns(from: awayStats)
	  let visitorHits = getVisitorHits(from: awayStats)
	  let visitorErrors = getVisitorErrors(from: awayStats)
	  let homeRuns = getHomeRuns(from: homeStats)
	  let homeHits = getHomeHits(from: homeStats)
	  let homeErrors = getHomeErrors(from: homeStats)

	  return gameEvent(title: title,
					   shortTitle: shortTitle,
					   home: homeTeamName,
					   visitors: awayTeamName,
					   homeRecord: homeRecord,
					   visitorRecord: visitorRecord,
					   inning: inning,
					   homeScore: homeScore,
					   visitScore: visitScore,
					   homeColor: homeColor,
					   homeAltColor: homeAltColor,
					   visitorColor: visitorColor,
					   visitorAltColor: visitorAltColor,
					   on1: on1,
					   on2: on2,
					   on3: on3,
					   lastPlay: lastPlay,
					   balls: balls,
					   strikes: strikes,
					   outs: outs,
					   homeLogo: homeLogo,
					   visitorLogo: visitorLogo,
					   inningTxt: inningTxt,
					   thisSubStrike: subStrike,
					   thisCalledStrike2: foulStrike2,
					   startDate: startDate,
					   startTime: startTime,
					   atBat: batterName,
					   atBatPic: batterPic,
					   atBatSummary: batterSummary ?? "N/A",
					   batterStats: batterStats,
					   batterLine: batterLine,
					   visitorRuns: visitorRuns,
					   visitorHits: visitorHits,
					   visitorErrors: visitorErrors,
					   homeRuns: homeRuns,
					   homeHits: homeHits,
					   homeErrors: homeErrors)

   }

   // Helper functions to extract specific stats (add these in your GameViewModel)

   // GameViewModel.swift (continued)
   private func getBatterStats(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
	  return stats[safe: 2]?.displayValue ?? "N/A"
   }

   private func getBatterLine(from team: APIResponse.Event.Competition.Competitor) -> String {
	  return team.leaders[safe: 0]?.leaders[safe: 0]?.displayValue ?? "N/A"
   }

   private func getVisitorRuns(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
	  return stats[safe: 1]?.displayValue ?? "N/A"
   }

   private func getVisitorHits(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
	  return stats[safe: 0]?.displayValue ?? "N/A"
   }

   private func getVisitorErrors(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
	  return stats[safe: 7]?.displayValue ?? "N/A"
   }

   private func getHomeRuns(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
	  return stats[safe: 1]?.displayValue ?? "N/A"
   }

   private func getHomeHits(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
	  return stats[safe: 0]?.displayValue ?? "N/A"
   }

   private func getHomeErrors(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
	  return stats[safe: 7]?.displayValue ?? "N/A"
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

// Safe indexing extension
extension Collection {
   subscript(safe index: Index) -> Element? {
	  return indices.contains(index) ? self[index] : nil
   }
}



