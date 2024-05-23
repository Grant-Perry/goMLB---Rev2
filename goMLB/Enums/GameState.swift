//   GameState.swift
//   goMLB
//
//   Created by: Grant Perry on 5/22/24 at 11:51 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

enum GameState: String, CaseIterable { // Added CaseIterable for easier iteration
   case final = "Final"
   case suspended = "Suspended"
   case top = "Top"
   case bottom = "Bottom"
   case middle = "Middle"

   init?(inningText: String) {
	  for state in GameState.allCases { // Use allCases for cleaner iteration
		 if inningText.contains(state.rawValue) {
			self = state
			return
		 }
	  }
	  return nil // No matching state found
   }

   // Computed property for formatting scores based on game state
   var scoreFormat: (Int, Int) -> String {
	  switch self {
		 case .final:
			return { (awayScore, homeScore) in // Use (awayScore, homeScore) for the closure arguments
			   "\(awayScore) | \(homeScore) (Final)"
			}
		 case .suspended:
			return { (awayScore, homeScore) in
			   "\(awayScore) | \(homeScore) (Suspended)"
			}
		 case .top, .bottom, .middle:
			return { (awayScore, homeScore) in
			   "\(awayScore) - \(homeScore) (\(self.rawValue))"
			}
	  }
   }
}
