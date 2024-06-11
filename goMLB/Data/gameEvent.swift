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
   var isInProgress: Bool { // remember this computed property way - i like 6/8/24
	  !inningTxt.contains("Final") && !inningTxt.contains("Scheduled")
   }
   var nextGameDisplayText: String {
	  if isInProgress {
		 return ""
	  } else if inningTxt.contains("Scheduled") {
		 //		 if startDate.isEmpty { startDate = Date() }
		 let dateFormatter = DateFormatter()
		 dateFormatter.dateFormat = "yyyy-MM-dd"

//		 print("startDate for : \(visitors) vs. \(home) is - \(startDate)")
		 if startDate == dateFormatter.string(from: Date()) || startDate.isEmpty { // Check if game is today
			return "Next Game: Today - \(startTime) at \(home)" // Display "Today" without date
		 } else {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMMM d"
			let formattedStartDate = dateFormatter.string(from: ISO8601DateFormatter().date(from: startDate) ?? Date())
			return "Next Game: \(formattedStartDate), \(startTime) at \(home)"
			//			return "Next Game: \(startDate), \(startTime) at \(home)" // Display full date
		 }
	  } else {
		 return "Final"
	  }
   }
}

