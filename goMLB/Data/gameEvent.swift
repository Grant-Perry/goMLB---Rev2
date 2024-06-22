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
   var currentPitcherPic: String
   var currentPitcherERA: String
   var currentPitcherPitchesThrown: Int
   var currentPitcherLastPitchSpeed: String?
   var currentPitcherLastPitchType: String?
   var currentPitcherID: String
   var currentPitcherThrows: String
   var currentPitcherWins: Int
   var currentPitcherLosses: Int
   var currentPitcherStrikeOuts: Int
   var homePitcherName: String
   var homePitcherPic: String?
   var homePitcherERA: String
   var homePitcherID: String
   var homePitcherThrows: String
   var homePitcherWins: Int
   var homePitcherLosses: Int
   var homePitcherStrikeOuts: Int
   var visitorPitcherName: String
   var visitorPitcherPic: String?
   var visitorPitcherERA: String
   var visitorPitcherID: String
   var visitorPitcherThrows: String
   var visitorPitcherWins: Int
   var visitorPitcherLosses: Int
   var visitorPitcherStrikeOuts: Int
   var atBatID: String
   var homeTeamOdds: [String: CodableValue]
   var awayTeamOdds: [String: CodableValue]
   var probHomePitcherName: String
   var probHomePitcherPic: String?
   var probHomePitcherERA: String
   var probHomePitcherThrows: String
   var probHomePitcherWins: Int
   var probHomePitcherLosses: Int
   var probHomePitcherStrikeOuts: Int
   var probVisitPitcherName: String
   var probVisitPitcherPic: String?
   var probVisitPitcherERA: String
   var probVisitPitcherThrows: String
   var probVisitPitcherWins: Int
   var probVisitPitcherLosses: Int
   var probVisitPitcherStrikeOuts: Int

   var currentPitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(currentPitcherID)"
   }

   var homePitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(homePitcherID)"
   }

   var visitorPitcherBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(visitorPitcherID)"
   }

   var batterBioURL: String {
	  "https://www.espn.com/mlb/player/_/id/\(atBatID)"
   }

   var isInProgress: Bool {
	  !inningTxt.contains("Final") && !inningTxt.contains("Scheduled")
   }

   var visitorWin: Bool {
	  return (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0)
   }

   var homeWin: Bool {
	  return (Int(homeScore) ?? 0) > (Int(visitScore) ?? 0)
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

// CodableValue to handle any value type in the dictionary
struct CodableValue: Codable {
   let value: Any

   init(_ value: Any) {
	  self.value = value
   }

   init(from decoder: Decoder) throws {
	  let container = try decoder.singleValueContainer()
	  if let value = try? container.decode(Bool.self) {
		 self.value = value
	  } else if let value = try? container.decode(Int.self) {
		 self.value = value
	  } else if let value = try? container.decode(Double.self) {
		 self.value = value
	  } else if let value = try? container.decode(String.self) {
		 self.value = value
	  } else {
		 throw DecodingError.typeMismatch(CodableValue.self,
										  DecodingError.Context(codingPath: decoder.codingPath,
																debugDescription: "Unsupported value"))
	  }
   }

   func encode(to encoder: Encoder) throws {
	  var container = encoder.singleValueContainer()
	  if let value = value as? Bool {
		 try container.encode(value)
	  } else if let value = value as? Int {
		 try container.encode(value)
	  } else if let value = value as? Double {
		 try container.encode(value)
	  } else if let value = value as? String {
		 try container.encode(value)
	  } else {
		 throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported value"))
	  }
   }
}

