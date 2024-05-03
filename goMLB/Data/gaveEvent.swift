//   gaveEvent.swift
//   goMLB
//
//   Created by: Grant Perry on 4/30/24 at 4:37 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import Foundation

struct gameEvent {
   var ID: UUID = UUID()
   var title: String        // Full title of the event.
   var shortTitle: String   // Shortened title of the event.
   var home: String         // Home team name.
   var visitors: String     // Visiting team name.
   var homeRecord: String  //  Home team's season record
   var visitorRecord: String  // Visitor's season record
   var inning: Int          // Current inning number.
   var homeScore: String    // Home team's current score.
   var visitScore: String   // Visitor team's current score.
   var homeColor: String 	// home colors
   var homeAltColor: String
   var visitorColor: String 	// visitors colors
   var visitorAltColor: String
   var on1: Bool            // Runner on first base.
   var on2: Bool            // Runner on second base.
   var on3: Bool            // Runner on third base.
   var lastPlay: String?    // Description of the last play.
   var balls: Int?          // Current ball count.
   var strikes: Int?        // Current strike count.
   var outs: Int?           // Current out count.
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
}
