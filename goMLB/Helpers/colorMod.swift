//   colorMod.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 3:29 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

extension Color {
   init(hex: String) {
	  let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
	  var int: UInt64 = 0
	  Scanner(string: hex).scanHexInt64(&int)
	  let a, r, g, b: UInt64
	  if hex.count == 6 {
		 (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
	  } else {
		 (a, r, g, b) = (255, 0, 0, 0) // Default to black on incorrect input
	  }
	  self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
   }
}
