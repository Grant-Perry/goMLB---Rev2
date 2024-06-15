import SwiftUI

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
			let statistics: [Statistic]?
			let probables: [Probable]?

			struct Team: Codable {
			   let name: String
			   let color: String?
			   let alternateColor: String?
			   let logo: String?
			   let logos: [Logo]?

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

			struct Probable: Codable {
			   let athlete: Athlete

			   struct Athlete: Codable {
				  let shortName: String?
				  let headshot: String?
				  let summary: String?
				  let id: String
				  let throwsHand: String? // Optional for batters
				  let statistics: [Statistic]?
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
			let pitcher: Pitcher?

			struct LastPlay: Codable {
			   let text: String?
			}

			struct Batter: Codable {
			   let athlete: Competitor.Probable.Athlete
			}

			struct Pitcher: Codable {
			   let athlete: Competitor.Probable.Athlete
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

