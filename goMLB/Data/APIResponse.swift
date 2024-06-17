//import Foundation
//
//struct APIResponseOLD: Codable {
//   let events: [Event]
//
//   struct EventLegacy: Codable, Identifiable {
//	  let id: String
//	  let name: String
//	  let date: Date
//	  let status: Status
//	  let competitions: [Competition]
//
//	  // Computed Properties for gameEvent
//	  var startDate: String {
//		 let dateFormatter = DateFormatter()
//		 dateFormatter.dateFormat = "yyyy-MM-dd"
//		 return dateFormatter.string(from: date)
//	  }
//
//	  var startTime: String {
//		 let dateFormatter = DateFormatter()
//		 dateFormatter.dateFormat = "HH:mm"
//		 return dateFormatter.string(from: date)
//	  }
//
//	  var home: String { competitions[0].competitors.first { $0.homeAway == "home" }?.team.name ?? "" }
//	  var homeLogo: String { competitions[0].competitors.first { $0.homeAway == "home" }?.team.logo ?? "" }
//	  var homeRecord: String { competitions[0].competitors.first { $0.homeAway == "home" }?.records?.first?.summary ?? "" }
//	  var homeColor: String { competitions[0].competitors.first { $0.homeAway == "home" }?.team.color ?? "" }
//	  var homeScore: String { competitions[0].competitors.first { $0.homeAway == "home" }?.score ?? "0" }
//
//	  var homeWin: Bool {
//		 guard let homeScoreInt = Int(homeScore),
//			   let visitorScoreInt = Int(visitorScore)
//		 else { return false }
//		 return homeScoreInt > visitorScoreInt
//	  }
//
//	  var homeProbablePitcher: String { homePitcher?.athlete.displayName ?? "TBD" }
//	  var homePitcherId: String { homePitcher?.athlete.id ?? "0" }
//	  var homePitcherThrows: String { homePitcher?.athlete.hand ?? "" }
//	  var homePitcherWins: String { homePitcher?.stats?.first(where: { $0.name == "wins" })?.displayValue ?? "0" }
//	  var homePitcherLosses: String { homePitcher?.stats?.first(where: { $0.name == "losses" })?.displayValue ?? "0" }
//	  var homePitcherEra: String { homePitcher?.stats?.first(where: { $0.name == "era" })?.displayValue ?? "0.00" }
//
//	  var visitor: String { competitions[0].competitors.first { $0.homeAway == "away" }?.team.name ?? "" }
//	  var visitorLogo: String { competitions[0].competitors.first { $0.homeAway == "away" }?.team.logo ?? "" }
//	  var visitorRecord: String { competitions[0].competitors.first { $0.homeAway == "away" }?.records?.first?.summary ?? "" }
//	  var visitorColor: String { competitions[0].competitors.first { $0.homeAway == "away" }?.team.color ?? "" }
//	  var visitorScore: String { competitions[0].competitors.first { $0.homeAway == "away" }?.score ?? "0" }
//
//	  var visitorWin: Bool {
//		 guard let homeScoreInt = Int(homeScore),
//			   let visitorScoreInt = Int(visitorScore)
//		 else { return false }
//		 return visitorScoreInt > homeScoreInt
//	  }
//
//	  var visitorProbablePitcher: String { visitorPitcher?.athlete.displayName ?? "TBD" }
//	  var visitorPitcherId: String { visitorPitcher?.athlete.id ?? "0" }
//	  var visitorPitcherThrows: String { visitorPitcher?.athlete.hand ?? "" }
//	  var visitorPitcherWins: String { visitorPitcher?.stats?.first(where: { $0.name == "wins" })?.displayValue ?? "0" }
//	  var visitorPitcherLosses: String { visitorPitcher?.stats?.first(where: { $0.name == "losses" })?.displayValue ?? "0" }
//	  var visitorPitcherEra: String { visitorPitcher?.stats?.first(where: { $0.name == "era" })?.displayValue ?? "0.00" }
//
//	  var inningTxt: String {
//		 switch status.type.name {
//			case "STATUS_IN_PROGRESS":
//			   return status.displayClock // Directly use the displayClock
//			case "STATUS_FINAL":
//			   // Extract inning information from the final status (if available)
//			   let regex = try? NSRegularExpression(pattern: "(\\d+)(st|nd|rd|th)", options: [])
//			   if let match = regex?.firstMatch(in: status.type.description, options: [], range: NSRange(status.type.description.startIndex..., in: status.type.description)) {
//				  return String(status.type.description[Range(match.range, in: status.type.description)!])
//			   }
//			   return "Final" // Explicitly return "Final" if regex extraction fails
//			default:
//			   return "Scheduled" // Default for other statuses
//		 }
//	  }
//
//	  var isInProgress: Bool {
//		 return !inningTxt.contains("Final") && !inningTxt.contains("Scheduled")
//	  }
//
//	  var inning: Int {
//		 guard isInProgress else { return 0 } // No need to wrap isInProgress in a boolean expression
//		 let components = status.displayClock.components(separatedBy: " ")
//		 return Int(components[1].replacingOccurrences(of: "[a-zA-Z]", with: "", options: .regularExpression)) ?? 0
//	  }
//
//	  var inningHalf: String? {
//		 return isInProgress ? status.type.inningHalf : nil
//	  }
//
//	  var outs: Int? { return competitions.first?.situation?.outs }
//	  var balls: Int? { return competitions.first?.situation?.balls }
//	  var strikes: Int? { return competitions.first?.situation?.strikes }
//	  var onFirst: Bool { return competitions.first?.situation?.onFirst ?? false }
//	  var onSecond: Bool { return competitions.first?.situation?.onSecond ?? false }
//	  var onThird: Bool { return competitions.first?.situation?.onThird ?? false }
//
//	  var atBat: String? {
//		 if let leader = competitions.first?.leaders?.first(where: { $0.name == "batting" }),
//			let athlete = leader.athletes.first {
//			return athlete.displayName
//		 }
//		 return nil
//	  }
//
//	  var atBatId: String? {
//		 if let leader = competitions.first?.leaders?.first(where: { $0.name == "batting" }),
//			let athlete = leader.athletes.first {
//			return athlete.athlete.id
//		 }
//		 return nil
//	  }
//
//	  var atBatPic: String? {
//		 if let leader = competitions.first?.leaders?.first(where: { $0.name == "batting" }),
//			let athlete = leader.athletes.first {
//			return athlete.athlete.headshot
//		 }
//		 return nil
//	  }
//
//	  var batterStats: String? {
//		 if let leader = competitions.first?.leaders?.first(where: { $0.name == "batting" }),
//			let athlete = leader.athletes.first {
//			if let avg = athlete.statistics.first(where: { $0.name == "battingAverage" }) {
//			   return avg.displayValue
//			}
//		 }
//		 return nil
//	  }
//
//	  var batterLine: String? {
//		 if let leader = competitions.first?.leaders?.first(where: { $0.name == "batting" }),
//			let athlete = leader.athletes.first {
//			if let hits = athlete.statistics.first(where: { $0.name == "hits" })?.displayValue,
//			   let atBats = athlete.statistics.first(where: { $0.name == "atBats" })?.displayValue {
//			   return "\(hits)-for-\(atBats)"
//			}
//		 }
//		 return nil
//	  }
//
//	  // Helper computed properties to access pitcher data
//	  private var visitorPitcher: Competition.Competitor.Probable? {
//		 return competitions.first?.competitors.first { $0.homeAway == "away" }?.probable
//	  }
//
//	  private var homePitcher: Competition.Competitor.Probable? {
//		 return competitions.first?.competitors.first { $0.homeAway == "home" }?.probable
//	  }
//
//	  struct Status: Codable {
//		 let type: EventType
//		 let displayClock: String
//		 let period: Int
//
//		 struct EventType: Codable {
//			let id: String
//			let name: String
//			let state: String
//			let description: String
//			let inningHalf: String? // Added inningHalf as a String
//		 }
//	  }
//
//	  struct Competition: Codable {
//		 let competitors: [Competitor]
//		 let situation: Situation?
//		 let leaders: [Leader]?
//
//		 struct Competitor: Codable {
//			let homeAway: String
//			let team: Team
//			let score: String
//			let winner: Bool
//			let records: [Record]?
//			let probable: Probable?
//
//			struct Team: Codable {
//			   let id: String
//			   let name: String
//			   let abbreviation: String
//			   let logo: String
//			   let color: String
//			}
//
//			struct Record: Codable {
//			   let summary: String
//			}
//
//			struct Probable: Codable {
//			   let athlete: Athlete
//			   let stats: [Stat]?
//
//			   struct Athlete: Codable {
//				  let displayName: String
//				  let id: String
//				  let hand: String
//				  let headshot: String?
//			   }
//
//			   struct Stat: Codable {
//				  let name: String
//				  let displayValue: String
//			   }
//			}
//		 }
//
//		 struct Situation: Codable {
//			let balls: Int
//			let strikes: Int
//			let outs: Int
//			let onFirst: Bool
//			let onSecond: Bool
//			let onThird: Bool
//			let batter: Batter?
//			let pitcher: Pitcher?
//
//			struct Batter: Codable {
//			   let athlete: Athlete?
//			   let summary: String?
//
//			   struct Athlete: Codable {
//				  let id: String
//				  let shortName: String
//				  let headshot: String?
//				  let statistics: [Statistic]?
//
//				  struct Statistic: Codable {
//					 let name: String
//					 let displayValue: String
//				  }
//			   }
//			}
//
//			struct Pitcher: Codable {
//			   let athlete: Athlete?
//
//			   struct Athlete: Codable {
//				  let id: String
//				  let shortName: String
//				  let hand: String
//				  let headshot: String?
//			   }
//			}
//		 }
//
//
//
//
//		 struct Leader: Codable {
//			let name: String
//			let displayName: String
//			let athletes: [Athlete]
//
//			struct Athlete: Codable {
//			   let displayName: String
//			   let athlete: AthleteInfo
//			   let statistics: [Statistic]
//
//			   struct AthleteInfo: Codable {
//				  let id: String
//				  let headshot: String?
//			   }
//
//			   struct Statistic: Codable {
//				  let name: String
//				  let displayValue: String
//			   }
//			}
//		 }
//	  }
//   }
//}
