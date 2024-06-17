//   GameViewModel.swift
//   Created by: Grant Perry on 4/23/24 at 4:36 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry

import SwiftUI
import Foundation

class GameViewModel: ObservableObject {
   @Published var filteredEvents: [gameEvent] = []
   @Published var allEvents: [gameEvent] = []
   @Published var teamPlaying: String = "Yankees"
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
   @Published var maxUpdates = 20
   @AppStorage("favTeam") var favTeam: String = "Yankees" // Default value

   // Pitcher Properties
   @Published var homePitcherName: String = ""
   @Published var homePitcherPic: String?
   @Published var homePitcherERA: String = ""
   @Published var homePitcherID: String = ""
   @Published var homePitcherThrows: String = ""
   @Published var homePitcherWins: Int = 0
   @Published var homePitcherLosses: Int = 0
   @Published var homePitcherStrikeOuts: Int = 0

   @Published var visitorPitcherName: String = ""
   @Published var visitorPitcherPic: String?
   @Published var visitorPitcherERA: String = ""
   @Published var visitorPitcherID: String = ""
   @Published var visitorPitcherThrows: String = ""
   @Published var visitorPitcherWins: Int = 0
   @Published var visitorPitcherLosses: Int = 0
   @Published var visitorPitcherStrikeOuts: Int = 0

   // Current Pitcher Properties
   @Published var currentPitcherName: String = ""
   @Published var currentPitcherPic: String = ""
   @Published var currentPitcherERA: String = ""
   @Published var currentPitcherID: String = ""
   @Published var currentPitcherThrows: String = ""
   @Published var currentPitcherWins: Int = 0
   @Published var currentPitcherLosses: Int = 0
   @Published var currentPitcherStrikeOuts: Int = 0
   @Published var currentPitcherPitchesThrown: Int = 0
   @Published var currentPitcherLastPitchSpeed: String? = nil
   @Published var currentPitcherLastPitchType: String? = nil

   // Computed Properties for Bio URLs
   var homePitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(homePitcherID)"
   }

   var visitorPitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(visitorPitcherID)"
   }

   var currentPitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(currentPitcherID)"
   }

   func loadAllGames(showLiveAction: Bool, completion: (() -> Void)? = nil) {
	  if isDebuggingEnabled {
		 if let path = Bundle.main.path(forResource: "gp", ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
			processGameData(data: data, showLiveAction: showLiveAction, completion: completion)
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
		 if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			let eventsArray = json["events"] as? [[String: Any]] {

			self.allEvents = eventsArray.compactMap { createGameEvent(from: $0) }

			DispatchQueue.main.async {
			   if showLiveAction {
				  self.filteredEvents = self.allEvents.filter { $0.isInProgress }
			   } else {
				  self.filteredEvents = self.allEvents.filter { $0.visitors.contains(self.teamPlaying) || $0.home.contains(self.teamPlaying) }
			   }
			   completion?()
			}
		 }
	  } catch {
		 print("Error decoding JSON: \(error)")
	  }
   }

   func createGameEvent(from dictionary: [String: Any]) -> gameEvent? {
	  guard
		 let id = dictionary["id"] as? String,
		 let name = dictionary["name"] as? String,
		 let competitions = dictionary["competitions"] as? [[String: Any]],
		 let competition = competitions.first,
		 let competitors = competition["competitors"] as? [[String: Any]],
		 let homeCompetitor = competitors.first(where: { $0["homeAway"] as? String == "home" }),
		 let awayCompetitor = competitors.first(where: { $0["homeAway"] as? String == "away" }),
		 let homeTeam = homeCompetitor["team"] as? [String: Any],
		 let awayTeam = awayCompetitor["team"] as? [String: Any],
		 let status = competition["status"] as? [String: Any],
		 let statusType = status["type"] as? [String: Any],
		 let situation = competition["situation"] as? [String: Any],
		 let homeScore = homeCompetitor["score"] as? String,
		 let awayScore = awayCompetitor["score"] as? String
	  else {
		 return nil
	  }

	  // Extract other necessary values
	  let homeRecord = (homeCompetitor["records"] as? [[String: Any]])?.first?["summary"] as? String ?? "N/A"
	  let awayRecord = (awayCompetitor["records"] as? [[String: Any]])?.first?["summary"] as? String ?? "N/A"
	  let homeColor = homeTeam["color"] as? String ?? "000000"
	  let homeAltColor = homeTeam["alternateColor"] as? String
	  let awayColor = awayTeam["color"] as? String ?? "000000"
	  let awayAltColor = awayTeam["alternateColor"] as? String
	  let homeLogo = homeTeam["logo"] as? String ?? ""
	  let awayLogo = awayTeam["logo"] as? String ?? ""
	  let inningTxt = (statusType["description"] as? [String: Any])?["shortDetail"] as? String ?? "N/A"
	  let startDate = dictionary["date"] as? String ?? "N/A"
	  let startTime = (statusType["description"] as? [String: Any])?["inningHalf"] as? String ?? "N/A"

	  // Handle pitcher and batter details
	  let homePitcher = homeCompetitor["probable"] as? [String: Any]
	  let awayPitcher = awayCompetitor["probable"] as? [String: Any]
	  let currentPitcher = situation["pitcher"] as? [String: Any]

	  // Extracting the actual values using your logic
	  let batterName = ((situation["atBat"] as? [String: Any])?["athlete"] as? [String: Any])?["displayName"] as? String ?? "N/A"
	  let batterPic = ((situation["atBat"] as? [String: Any])?["athlete"] as? [String: Any])?["headshot"] as? String ?? ""
	  let batterSummary = (situation["atBat"] as? [String: Any])?["summary"] as? String ?? "N/A"
	  let batterAvg = ((situation["atBat"] as? [String: Any])?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "avg" })?["displayValue"] as? String ?? "N/A"
	  let batterLine = (situation["atBat"] as? [String: Any])?["line"] as? String ?? "N/A"

	  return gameEvent(
		 title: name,
		 shortTitle: name, // Adjust as needed
		 home: homeTeam["name"] as? String ?? "",
		 visitors: awayTeam["name"] as? String ?? "",
		 homeRecord: homeRecord,
		 visitorRecord: awayRecord,
		 inning: status["period"] as? Int ?? 1,
		 homeScore: homeScore,
		 visitScore: awayScore,
		 homeColor: homeColor,
		 homeAltColor: homeAltColor,
		 visitorColor: awayColor,
		 visitorAltColor: awayAltColor,
		 on1: situation["onFirst"] as? Bool ?? false,
		 on2: situation["onSecond"] as? Bool ?? false,
		 on3: situation["onThird"] as? Bool ?? false,
		 lastPlay: situation["lastPlay"] as? String,
		 balls: situation["balls"] as? Int,
		 strikes: situation["strikes"] as? Int,
		 outs: situation["outs"] as? Int,
		 homeLogo: homeLogo,
		 visitorLogo: awayLogo,
		 inningTxt: inningTxt,
		 thisSubStrike: subStrike,
		 thisCalledStrike2: foulStrike2,
		 startDate: startDate,
		 startTime: startTime,
		 atBat: batterName,
		 atBatPic: batterPic,
		 atBatSummary: batterSummary,
		 batterStats: batterAvg,
		 batterLine: batterLine,
		 visitorRuns: awayScore,
		 visitorHits: situation["hits"] as? String ?? "0",
		 visitorErrors: situation["errors"] as? String ?? "0",
		 homeRuns: homeScore,
		 homeHits: situation["hits"] as? String ?? "0",
		 homeErrors: situation["errors"] as? String ?? "0",
		 currentPitcherName: (currentPitcher?["athlete"] as? [String: Any])?["displayName"] as? String ?? "TBD",
		 currentPitcherPic: (currentPitcher?["athlete"] as? [String: Any])?["headshot"] as? String ?? "",
		 currentPitcherERA: (currentPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "ERA" })?["displayValue"] as? String ?? "0.00",
		 currentPitcherPitchesThrown: Int((currentPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "pitchesThrown" })?["displayValue"] as? String ?? "0") ?? 0,
		 currentPitcherLastPitchSpeed: (currentPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "lastPitchSpeed" })?["displayValue"] as? String,
		 currentPitcherLastPitchType: (currentPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "lastPitchType" })?["displayValue"] as? String,
		 currentPitcherID: (currentPitcher?["athlete"] as? [String: Any])?["id"] as? String ?? "",
		 currentPitcherThrows: (currentPitcher?["athlete"] as? [String: Any])?["hand"] as? String ?? "",
		 currentPitcherWins: Int((currentPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "wins" })?["displayValue"] as? String ?? "0") ?? 0,
		 currentPitcherLosses: Int((currentPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "losses" })?["displayValue"] as? String ?? "0") ?? 0,
		 currentPitcherStrikeOuts: Int((currentPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "strikeOuts" })?["displayValue"] as? String ?? "0") ?? 0,
		 homePitcherName: (homePitcher?["athlete"] as? [String: Any])?["displayName"] as? String ?? "TBD",
		 homePitcherPic: (homePitcher?["athlete"] as? [String: Any])?["headshot"] as? String,
		 homePitcherERA: (homePitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "ERA" })?["displayValue"] as? String ?? "0.00",
		 homePitcherID: (homePitcher?["athlete"] as? [String: Any])?["id"] as? String ?? "",
		 homePitcherThrows: (homePitcher?["athlete"] as? [String: Any])?["hand"] as? String ?? "",
		 homePitcherWins: Int((homePitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "wins" })?["displayValue"] as? String ?? "0") ?? 0,
		 homePitcherLosses: Int((homePitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "losses" })?["displayValue"] as? String ?? "0") ?? 0,
		 homePitcherStrikeOuts: Int((homePitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "strikeOuts" })?["displayValue"] as? String ?? "0") ?? 0,
		 visitorPitcherName: (awayPitcher?["athlete"] as? [String: Any])?["displayName"] as? String ?? "TBD",
		 visitorPitcherPic: (awayPitcher?["athlete"] as? [String: Any])?["headshot"] as? String,
		 visitorPitcherERA: (awayPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "ERA" })?["displayValue"] as? String ?? "0.00",
		 visitorPitcherID: (awayPitcher?["athlete"] as? [String: Any])?["id"] as? String ?? "",
		 visitorPitcherThrows: (awayPitcher?["athlete"] as? [String: Any])?["hand"] as? String ?? "",
		 visitorPitcherWins: Int((awayPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "wins" })?["displayValue"] as? String ?? "0") ?? 0,
		 visitorPitcherLosses: Int((awayPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "losses" })?["displayValue"] as? String ?? "0") ?? 0,
		 visitorPitcherStrikeOuts: Int((awayPitcher?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "strikeOuts" })?["displayValue"] as? String ?? "0") ?? 0,
		 atBatID: situation["atBatId"] as? String ?? ""
	  )
   }

   // Helper functions to extract specific stats (add these in your GameViewModel)

   func loadFavoriteTeamGames(completion: (() -> Void)? = nil) {
	  teamPlaying = favTeam // Set teamPlaying to the favorite team
	  loadAllGames(showLiveAction: false, completion: completion) // Load games for the favorite team
   }

   func setFavoriteTeam(teamName: String) {
	  favTeam = teamName
   }


//
//   private func getHomeErrors(from stats: [APIResponse.Event.Competition.Competitor.Statistic]) -> String {
//	  return stats.first(where: { $0.name == "errors" })?.displayValue ?? "N/A"
//   }

   private func extractDateAndTime(from dateString: String) {
	  let parts = dateString.split(separator: "T")
	  if parts.count == 2 {
		 self.startDate = String(parts[0])
		 self.startTime = String(parts[1].dropLast())
	  }
   }

//   func extractPitcherInformation(from competitor: APIResponse.Event.Competition.Competitor, forTeam isHomeTeam: Bool) {
//	  if let probables = competitor.probables,
//		 let probable = probables.first,
//		 let athlete = probable.athlete,
//		 let stats = athlete.statistics {
//
//		 let name = athlete.shortName
//		 let pic = athlete.headshot
//		 let id = athlete.id
//		 let throwsHand = athlete.throwsHand ?? ""
//
//		 var wins = 0
//		 var losses = 0
//		 var era = ""
//		 var strikeouts = 0
//
//		 for stat in stats {
//			if let abbreviation = stat.abbreviation,
//			   let displayValue = stat.displayValue {
//			   switch abbreviation {
//				  case "W": wins = Int(displayValue) ?? 0
//				  case "L": losses = Int(displayValue) ?? 0
//				  case "ERA": era = displayValue
//				  case "K": strikeouts = Int(displayValue) ?? 0
//				  default: break
//			   }
//			}
//		 }
//
//		 if isHomeTeam {
//			homePitcherName = name
//			homePitcherPic = pic
//			homePitcherERA = era
//			homePitcherID = id
//			homePitcherThrows = throwsHand
//			homePitcherWins = wins
//			homePitcherLosses = losses
//			homePitcherStrikeOuts = strikeouts
//		 } else {
//			visitorPitcherName = name
//			visitorPitcherPic = pic
//			visitorPitcherERA = era
//			visitorPitcherID = id
//			visitorPitcherThrows = throwsHand
//			visitorPitcherWins = wins
//			visitorPitcherLosses = losses
//			visitorPitcherStrikeOuts = strikeouts
//		 }
//	  }
//   }
}

