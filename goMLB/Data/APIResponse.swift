//   APIResponse.swift
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
// Top-level API response
struct APIResponse: Codable {
   var events: [Event]
}

// Event structure
struct Event: Codable {
   var name: String
   var shortName: String
   var competitions: [Competition]
   var status: EventStatus
   var date: String
}

// Competition structure
struct Competition: Codable {
   var competitors: [Competitor]
   var situation: Situation?
   var status: Status

   struct Status: Codable {
	  var type: TypeDetail

	  struct TypeDetail: Codable {
		 var detail: String
	  }
   }
}

// Competitor structure
struct Competitor: Codable {
   var team: Team
   var score: String?
   var records: [Record]
}

// Team structure
struct Team: Codable {
   var name: String
   var logo: String
   var color: String
   var alternateColor: String
}

// Record structure
struct Record: Codable {
   var summary: String
}

// Situation structure
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

// Batter structure
struct Batter: Codable {
   var athlete: Athlete
}

// Athlete structure
struct Athlete: Codable {
   var shortName: String
   var headshot: String
   var summary: String?
}

// LastPlay structure
struct LastPlay: Codable {
   var text: String?
}

// EventStatus structure
struct EventStatus: Codable {
   var period: Int
}
