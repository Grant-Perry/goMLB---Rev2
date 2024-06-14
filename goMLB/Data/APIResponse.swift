import SwiftUI
import Foundation

struct APIResponse: Codable {
   let events: [Event]

   struct Event: Codable {
	  let competitions: [Competition]
	  let date: String
	  let id: String
	  let name: String
	  let shortName: String
	  let status: Status

	  struct Competition: Codable {
		 let competitors: [Competitor]
		 let situation: Situation?
		 let status: CompetitionStatus

		 struct Competitor: Codable {
			let team: Team
			let score: String?
			let records: [Record]?
			let statistics: [Statistic]
			let leaders: [LeaderBoard]

			struct Team: Codable {
			   let name: String
			   let color: String?
			   let alternateColor: String?
			   let logo: String? // Retain the existing logo for backward compatibility
			   let logos: [Logo]? // Add the logos array

			   struct Logo: Codable {
				  let href: String
				  let width: Int?
				  let height: Int?
			   }
			}

			struct Record: Codable {
			   let summary: String
			}

			struct Statistic: Codable {
			   let name: String
			   let displayValue: String
			}

			struct LeaderBoard: Codable {
			   let leaders: [Leader]

			   struct Leader: Codable {
				  let displayValue: String
			   }
			}
		 }

		 struct Situation: Codable {
			let balls: Int?
			let strikes: Int?
			let outs: Int?
			let onFirst: Bool?
			let onSecond: Bool?
			let onThird: Bool?
			let lastPlay: LastPlay?
			let batter: Batter?

			struct LastPlay: Codable {
			   let text: String?
			}

			struct Batter: Codable {
			   let athlete: Athlete

			   struct Athlete: Codable {
				  let shortName: String
				  let headshot: String
				  let summary: String? // Make summary optional
			   }

			}
		 }

		 struct CompetitionStatus: Codable {
			let type: StatusType

			struct StatusType: Codable {
			   let detail: String
			}
		 }
	  }

	  struct Status: Codable {
		 let period: Int?
	  }
   }
}
