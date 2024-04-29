//   JSONModels.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 4:37 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//


import SwiftUI

/// `APIResponse` holds an array of `Event` objects.
/// It is used as the top-level model for decoding JSON data from the API.
struct APIResponse: Codable {
   /// An array of events, each representing a distinct game or match fetched from the API.
   var events: [Event]
}

struct Event: Codable {
   var name: String
   var shortName: String
   var competitions: [Competition]
   var status: EventStatus
   var date: String  
}

struct Competition: Codable {
   var competitors: [Competitor]
   var situation: Situation?
	var status: Status // Add this line assuming 'status' is part of the JSON

	struct Status: Codable {
		var type: TypeDetail

		struct TypeDetail: Codable {
			var detail: String
		}
	}
}

struct Competitor: Codable {
   var team: Team
   var score: String?  // Current score for the competitor; optional because a game might not have started.
   var records: [Record]
}

struct Record: Codable {
   var summary: String // holds the team's season record prior to current game i.e. 18-6
}

struct Team: Codable {
   var name: String
   var logo: String
   var color: String // team's color
   var alternateColor: String // team's color
}

struct Situation: Codable {
   var balls: Int?
   var strikes: Int?
   var outs: Int?
   var onFirst: Bool?
   var onSecond: Bool?
   var onThird: Bool?
   var lastPlay: LastPlay?
	var batter: Batter?
}

struct Batter: Codable {
	var athlete: Athlete
}

struct Athlete: Codable {
	var shortName: String
	var headshot: String
	var summary: String? //events[6].competitions[0].situation.batter.summary
}
struct LastPlay: Codable {
   var text: String?
}

struct EventStatus: Codable {
   var period: Int
}
