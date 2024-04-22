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

/// `Event` represents a sports event, including its name, status, and competitions involved.
struct Event: Codable {
   /// The full name of the event.
   var name: String
   /// A shortened version of the event's name.
   var shortName: String
   /// An array of competitions associated with the event.
   var competitions: [Competition]
   /// Status of the event, such as current period or inning.
   var status: EventStatus
}

/// `Competition` includes participants (competitors) and potentially the current game situation.
struct Competition: Codable {
   /// Competitors participating in this competition, typically representing teams.
   var competitors: [Competitor]
   /// Optional current situation of the game, such as player positions or current play.
   var situation: Situation?
}

/// `Competitor` defines a participant in the competition, including the team details and current score.
struct Competitor: Codable {
   /// Team details for the competitor.
   var team: Team
   /// Current score for the competitor; optional because a game might not have started.
   var score: String?
}

/// `Team` provides basic information about a team including its name and logo URL.
struct Team: Codable {
   /// Name of the team.
   var name: String
   /// URL string of the team's logo.
   var logo: String
}

/// `Situation` represents the current state of play, providing detailed game conditions.
struct Situation: Codable {
   /// Current number of balls in the ongoing baseball play; optional because it may not be applicable to all sports.
   var balls: Int?
   /// Current number of strikes in the ongoing play; optional for the same reason as balls.
   var strikes: Int?
   /// Current number of outs in the ongoing play; optional and specific to sports like baseball.
   var outs: Int?
   /// Indicates if there is a player on first base; optional and baseball-specific.
   var onFirst: Bool?
   /// Indicates if there is a player on second base; optional and specific to baseball.
   var onSecond: Bool?
   /// Indicates if there is a player on third base; optional and specific to baseball.
   var onThird: Bool?
   /// Details of the last play that occurred in the game; optional and can provide context like play descriptions.
   var lastPlay: LastPlay?
}

/// `LastPlay` describes the most recent action or play that occurred in the game.
struct LastPlay: Codable {
   /// Descriptive text of the last play; optional as it may not always be relevant or available.
   var text: String?
}

/// `EventStatus` provides details about the current period or stage of the event.
struct EventStatus: Codable {
   /// Represents the current period of the event, such as an inning in baseball.
   var period: Int
}
