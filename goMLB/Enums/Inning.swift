//   Inning.swift
//   goMLB
//
//   Created by: Grant Perry on 5/18/24 at 1:09 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

enum Inning: String {
   case top = "arrowtriangle.up.fill"
   case bottom = "arrowtriangle.down.fill"
   case middle = "repeat.circle.fill"
   case unknown = "questionmark.bubble.fill"
}

func getInningSymbol(inningTxt: String) -> Inning {
   if inningTxt.contains("Top") {
	  return .top
   } else if inningTxt.contains("Bottom") {
	  return .bottom
   } else if inningTxt.contains("Middle") {
	  return .middle
   } else {
	  return .unknown
   }
}

