import SwiftUI
import Foundation

struct APIResponse: Codable {
   let events: [Event]

   struct Event: Codable {
	  let name: String
	  let shortName: String
	  let competitions: [Competition]
	  let date: String
	  let status: Status
   }

   struct Competition: Codable {
	  let competitors: [Competitor]
	  let situation: Situation?
	  let status: Status
   }

   struct Competitor: Codable {
	  let statistics: [Statistic]
	  let leaders: [Leader]
	  let team: Team
	  let score: String?
	  let records: [Record]
   }

   struct Statistic: Codable {
	  let displayValue: String
	  let name: String
   }

   struct Leader: Codable {
	  let leaders: [LeaderDetail]
   }

   struct LeaderDetail: Codable {
	  let displayValue: String
   }

   struct Situation: Codable {
	  let balls: Int
	  let strikes: Int
	  let outs: Int
	  let onFirst: Bool
	  let onSecond: Bool
	  let onThird: Bool
	  let lastPlay: LastPlay?
	  let batter: Batter?
   }

   struct LastPlay: Codable {
	  let text: String
   }

   struct Batter: Codable {
	  let athlete: Athlete
   }

   struct Athlete: Codable {
	  let shortName: String
	  let headshot: String
	  let summary: String
   }

   struct Team: Codable {
	  let name: String
	  let color: String
	  let alternateColor: String
	  let logo: String
   }

   struct Record: Codable {
	  let summary: String
   }

   struct Status: Codable {
	  let type: StatusType
	  let period: Int
   }

   struct StatusType: Codable {
	  let detail: String
   }
}



