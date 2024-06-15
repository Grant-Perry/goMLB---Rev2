import SwiftUI

struct gameEvent: Codable, Identifiable {
   var id: UUID = UUID()
   var title: String
   var shortTitle: String
   var home: String
   var visitors: String
   var homeRecord: String
   var visitorRecord: String
   var inning: Int
   var homeScore: String
   var visitScore: String
   var homeColor: String
   var homeAltColor: String?
   var visitorColor: String
   var visitorAltColor: String?
   var on1: Bool
   var on2: Bool
   var on3: Bool
   var lastPlay: String?
   var balls: Int?
   var strikes: Int?
   var outs: Int?
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
   var batterStats: String
   var batterLine: String
   var visitorRuns: String
   var visitorHits: String
   var visitorErrors: String
   var homeRuns: String
   var homeHits: String
   var homeErrors: String
   var currentPitcherName: String
   var currentPitcherPic: String?
   var currentPitcherERA: String
   var currentPitcherPitchesThrown: Int
   var currentPitcherLastPitchSpeed: String?
   var currentPitcherLastPitchType: String?
   var currentPitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(currentPitcherID)"
   }
   var currentPitcherID: String
   var currentPitcherThrows: String
   var currentPitcherWins: Int
   var currentPitcherLosses: Int
   var currentPitcherStrikeOuts: Int
   var homePitcherName: String
   var homePitcherPic: String?
   var homePitcherERA: String
   var homePitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(homePitcherID)"
   }
   var homePitcherID: String
   var homePitcherThrows: String
   var homePitcherWins: Int
   var homePitcherLosses: Int
   var homePitcherStrikeOuts: Int
   var atBatID: String
   var batterBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(atBatID)"
   }

   var isInProgress: Bool {
	  !inningTxt.contains("Final") && !inningTxt.contains("Scheduled")
   }

   var nextGameDisplayText: String {
	  if isInProgress {
		 return ""
	  } else if inningTxt.contains("Scheduled") {
		 let dateFormatter = DateFormatter()
		 dateFormatter.dateFormat = "yyyy-MM-dd"
		 if startDate == dateFormatter.string(from: Date()) || startDate.isEmpty {
			return "Next Game: Today - \(startTime) at \(home)"
		 } else {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMMM d"
			let formattedStartDate = dateFormatter.string(from: ISO8601DateFormatter().date(from: startDate) ?? Date())
			return "Next Game: \(formattedStartDate), \(startTime) at \(home)"
		 }
	  } else {
		 return "Final"
	  }
   }
}
