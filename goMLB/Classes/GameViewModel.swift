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
		 // Load data from the local "gp.json" file
		 if let path = Bundle.main.path(forResource: "gp", ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
			processGameData(data: data, showLiveAction: showLiveAction) {
			   DispatchQueue.main.async {
				  completion?()
			   }
			}
		 }
	  } else {
		 // Load data from the ESPN API
		 guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard") else { return }

		 URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
			   print("Network error: \(error?.localizedDescription ?? "No error description")")
			   return
			}
			self.processGameData(data: data, showLiveAction: showLiveAction) {
			   DispatchQueue.main.async {
				  completion?()
			   }
			}
		 }.resume()
	  }
   }

   private func processGameData(data: Data, showLiveAction: Bool, completion: (() -> Void)? = nil) {
	  do {
		 if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			let eventsArray = json["events"] as? [[String: Any]] {

			let events = eventsArray.compactMap { createGameEvent(from: $0) }

			DispatchQueue.main.async {
			   self.allEvents = events

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
		 let homeScore = homeCompetitor["score"] as? String,
		 let awayScore = awayCompetitor["score"] as? String
	  else {
		 return nil
	  }

	  let situation = competition["situation"] as? [String: Any] ?? [:]
	  let inningTxt = statusType["description"] as? String ?? ""
	  let startDateString = dictionary["date"] as? String ?? "N/A"
	  let (startDate, startTime) = extractDateAndTime(from: startDateString)
//	  print("startTime: \(startDate) at \(startTime)\n---------------- ")

	  // Extract homeTeamOdds and awayTeamOdds
	  var homeTeamOdds: [String: CodableValue] = [:]
	  var awayTeamOdds: [String: CodableValue] = [:]

	  // Extract odds information
	  let oddsInfo = extractOddsInfo(from: competition)
	  let homeOddsUnderdog = oddsInfo.homeOddsUnderdog
	  let homeOddsSpreadValue = oddsInfo.homeOddsSpreadValue
	  let homeOddsSpreadDisplay = oddsInfo.homeOddsSpreadDisplay
	  let awayOddsUnderdog = oddsInfo.awayOddsUnderdog
	  _ = oddsInfo.awayOddsSpreadValue
	  let awayOddsSpreadDisplay = oddsInfo.awayOddsSpreadDisplay

//	  print("Home Odds - Underdog: \(homeOddsUnderdog), Spread Value: \(homeOddsSpreadValue), Spread Display: \(homeOddsSpreadDisplay)")
//	  print("Away Odds - Underdog: \(awayOddsUnderdog), Spread Value: \(awayOddsSpreadValue), Spread Display: \(awayOddsSpreadDisplay)")

	  // Extract other necessary values
	  let homeRecord = (homeCompetitor["records"] as? [[String: Any]])?.first?["summary"] as? String ?? "N/A"
	  let awayRecord = (awayCompetitor["records"] as? [[String: Any]])?.first?["summary"] as? String ?? "N/A"
	  let homeColor = homeTeam["color"] as? String ?? "000000"
	  let homeAltColor = homeTeam["alternateColor"] as? String
	  let awayColor = awayTeam["color"] as? String ?? "000000"
	  let awayAltColor = awayTeam["alternateColor"] as? String
	  let homeLogo = homeTeam["logo"] as? String ?? ""
	  let awayLogo = awayTeam["logo"] as? String ?? ""



	  // Handle pitcher and batter details
	  let homePitcher = homeCompetitor["probable"] as? [String: Any]
	  let awayPitcher = awayCompetitor["probable"] as? [String: Any]
	  let currentPitcher = situation["pitcher"] as? [String: Any]
	  let probHomePitcher: [String: Any]? = (homeCompetitor["probables"] as? [[String: Any]])?.first
	  let probVisitPitcher: [String: Any]? = (awayCompetitor["probables"] as? [[String: Any]])?.first

	  // Extracting the actual values using your logic
	  let batterName = ((situation["atBat"] as? [String: Any])?["athlete"] as? [String: Any])?["displayName"] as? String ?? "N/A"
	  _ = batterName
	  let batterPic = ((situation["atBat"] as? [String: Any])?["athlete"] as? [String: Any])?["headshot"] as? String ?? ""
	  let atBatPic = batterPic
	  let batterSummary = (situation["atBat"] as? [String: Any])?["summary"] as? String ?? "N/A"
	  let atBatSummary = batterSummary
	  let batterAvg = ((situation["atBat"] as? [String: Any])?["statistics"] as? [[String: Any]])?.first(where: { $0["name"] as? String == "avg" })?["displayValue"] as? String ?? "N/A"
	  let atBatAvg = batterAvg
	  let batterLine = (situation["atBat"] as? [String: Any])?["line"] as? String ?? "N/A"
	  let atBatLine = batterLine

	  // Calculate subStrike and foulStrike2
	  let (subStrike, foulStrike2) = calculateSubStrikeAndFoulStrike2(balls: situation["balls"] as? Int ?? 0, strikes: situation["strikes"] as? Int ?? 0, lastPlay: situation["lastPlay"] as? String ?? "")

	  let gEvent = gameEvent(
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
		 atBatID: situation["atBatId"] as? String ?? "",
		 homeTeamOdds: homeTeamOdds,
		 awayTeamOdds: awayTeamOdds,
		 probHomePitcherName: probHomePitcher?["name"] as? String ?? "",
		 probHomePitcherPic: probHomePitcher?["pic"] as? String,
		 probHomePitcherERA: probHomePitcher?["era"] as? String ?? "",
		 probHomePitcherThrows: probHomePitcher?["throws"] as? String ?? "",
		 probHomePitcherWins: probHomePitcher?["wins"] as? Int ?? 0,
		 probHomePitcherLosses: probHomePitcher?["losses"] as? Int ?? 0,
		 probHomePitcherStrikeOuts: probHomePitcher?["strikeOuts"] as? Int ?? 0,
		 probVisitPitcherName: probVisitPitcher?["name"] as? String ?? "",
		 probVisitPitcherPic: probVisitPitcher?["pic"] as? String,
		 probVisitPitcherERA: probVisitPitcher?["era"] as? String ?? "",
		 probVisitPitcherThrows: probVisitPitcher?["throws"] as? String ?? "",
		 probVisitPitcherWins: probVisitPitcher?["wins"] as? Int ?? 0,
		 probVisitPitcherLosses: probVisitPitcher?["losses"] as? Int ?? 0,
		 probVisitPitcherStrikeOuts: probVisitPitcher?["strikeOuts"] as? Int ?? 0
	  )

//	  showGameEvent(thisGameEvent: gEvent)
	  return gEvent
   }

   // Assuming calculateSubStrikeAndFoulStrike2 is defined somewhere in your code
   func calculateSubStrikeAndFoulStrike2(balls: Int, strikes: Int, lastPlay: String) -> (Int, Bool) {
	  // Add your logic here
	  return (0, false) // Example return values
   }

   func showGameEvent(thisGameEvent: gameEvent?) {
	  if let gameEvent = thisGameEvent {
//	  if let gameEvent = thisGameEvent, gameEvent.home == "New York Yankees" || gameEvent.visitors == "New York Yankees" {
		 print("\n____________________[ \(gameEvent.visitors) vs. \(gameEvent.home) ]_______________________________________________________\n")
		 print("Game Event:")
		 let mirror = Mirror(reflecting: gameEvent)
		 for child in mirror.children {
			if let propertyName = child.label {
			   print("\(propertyName): \(child.value)")
			}
		 }

	  }
   }

   // Helper functions to extract specific stats (add these in your GameViewModel)

   func loadFavoriteTeamGames(completion: (() -> Void)? = nil) {
	  teamPlaying = favTeam // Set teamPlaying to the favorite team
	  loadAllGames(showLiveAction: false) {
		 completion?()
	  }    }

   func setFavoriteTeam(teamName: String) {
	  favTeam = teamName
   }

   private func extractDateAndTime(from dateString: String) -> (String, String) {
	  // Create a DateFormatter for parsing the input date string
	  let dateFormatter = DateFormatter()
	  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
	  dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure it's parsed as UTC

	  if let date = dateFormatter.date(from: dateString) {
		 // Format start date
		 let dateFormatter = DateFormatter()
		 dateFormatter.dateFormat = "yyyy-MM-dd"
		 let startDate = dateFormatter.string(from: date)

		 // Format start time considering EST/EDT
		 let timeFormatter = DateFormatter()
		 timeFormatter.dateFormat = "h:mm a"
		 timeFormatter.timeZone = TimeZone(abbreviation: "EST") ?? TimeZone.current
		 let startTime = timeFormatter.string(from: date)

		 return (startDate, startTime)
	  } else {
		 return ("N/A", "N/A")
	  }
   }

   func extractOddsInfo(from competition: [String: Any]) -> (homeOddsUnderdog: Bool, homeOddsSpreadValue: Double, homeOddsSpreadDisplay: String, awayOddsUnderdog: Bool, awayOddsSpreadValue: Double, awayOddsSpreadDisplay: String) {
	  var homeOddsUnderdog: Bool = false
	  var homeOddsSpreadValue: Double = 0.0
	  var homeOddsSpreadDisplay: String = "EVEN"

	  var awayOddsUnderdog: Bool = false
	  var awayOddsSpreadValue: Double = 0.0
	  var awayOddsSpreadDisplay: String = "EVEN"

	  if let oddsArray = competition["odds"] as? [[String: Any]] {
		 for odds in oddsArray {
			if let homeOdds = odds["homeTeamOdds"] as? [String: Any] {
			   homeOddsUnderdog = homeOdds["underdog"] as? Bool ?? false
			   if let pointSpread = homeOdds["close"] as? [String: Any],
				  let pointSpreadValue = pointSpread["pointSpread"] as? [String: Any] {
				  homeOddsSpreadValue = pointSpreadValue["value"] as? Double ?? 0.0
				  homeOddsSpreadDisplay = pointSpreadValue["alternateDisplayValue"] as? String ?? "EVEN"
			   }
			}
			if let awayOdds = odds["awayTeamOdds"] as? [String: Any] {
			   awayOddsUnderdog = awayOdds["underdog"] as? Bool ?? false
			   if let pointSpread = awayOdds["close"] as? [String: Any],
				  let pointSpreadValue = pointSpread["pointSpread"] as? [String: Any] {
				  awayOddsSpreadValue = pointSpreadValue["value"] as? Double ?? 0.0
				  awayOddsSpreadDisplay = pointSpreadValue["alternateDisplayValue"] as? String ?? "EVEN"
			   }
			}
		 }
	  }

	  return (homeOddsUnderdog, homeOddsSpreadValue, homeOddsSpreadDisplay, awayOddsUnderdog, awayOddsSpreadValue, awayOddsSpreadDisplay)
   }


   private func convertTo12HourFormat(from dateString: String, DST: Bool) -> String {
	  let isoDateFormatter = ISO8601DateFormatter()
	  isoDateFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
	  if let date = isoDateFormatter.date(from: dateString) {
		 let dateFormatter = DateFormatter()
		 dateFormatter.dateFormat = "h:mm a"
		 dateFormatter.timeZone = TimeZone.current
		 if DST {
			dateFormatter.timeZone = TimeZone(abbreviation: "EDT")!
		 }
		 return dateFormatter.string(from: date)
	  } else {
		 return "Invalid Date"
	  }
   }
}
