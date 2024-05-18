//   colorMod.swift
//   goMLB
//
//   Created by: Grant Perry on 4/23/24 at 3:29 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

//extension Color {
//   init(hex: String) {
//	  let rgb = hexToRGB(hex: hex) ?? (red: 1, green: 1, blue: 1) // Default to white
//	  self.init(.sRGB, red: rgb.red, green: rgb.green, blue: rgb.blue, opacity: 1)
//   }
//   init(hex: String) {
//	  let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//	  var int: UInt64 = 0
//	  Scanner(string: hex).scanHexInt64(&int)
//	  let a, r, g, b: UInt64
//	  if hex.count == 6 {
//		 (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//	  } else {
//		 (a, r, g, b) = (255, 0, 0, 0) // Default to black on incorrect input
//	  }
//	  self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//   }


// Convert hex string to RGB values
func hexToRGB(hex: String) -> (red: Double, green: Double, blue: Double)? {
   var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
   if hexSanitized.hasPrefix("#") {
	  hexSanitized.remove(at: hexSanitized.startIndex)
   }

   var rgbValue: UInt64 = 0
   Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

   let red = Double((rgbValue >> 16) & 0xff) / 255
   let green = Double((rgbValue >> 8) & 0xff) / 255
   let blue = Double(rgbValue & 0xff) / 255

   return (red, green, blue)
}

// Determine if the color is too dark based on a customizable threshold
func isColorTooDark(colorHex: String, thresholdHex: String) -> Bool {
   guard let colorRGB = hexToRGB(hex: colorHex),
		 let thresholdRGB = hexToRGB(hex: thresholdHex) else {
	  return false // Return false if hex conversion fails
   }

   // Calculate luminance for both color and threshold
   let colorLuminance = (0.299 * colorRGB.red) + (0.587 * colorRGB.green) + (0.114 * colorRGB.blue)
   let thresholdLuminance = (0.299 * thresholdRGB.red) + (0.587 * thresholdRGB.green) + (0.114 * thresholdRGB.blue)

   return colorLuminance < thresholdLuminance
}

// SwiftUI Color extension to initialize from hex string
extension Color {
   init(hex: String) {
	  let rgb = hexToRGB(hex: hex) ?? (red: 1, green: 1, blue: 1) // Default to white
	  self.init(.sRGB, red: rgb.red, green: rgb.green, blue: rgb.blue, opacity: 1)
   }
}

// Use the utility function to determine the color
func getColorForUI(hex: String, thresholdHex: String) -> Color {
   if isColorTooDark(colorHex: hex, thresholdHex: thresholdHex) {
	  return Color.white // Use white if the color is too dark
   } else {
	  return Color.white  // REMOVE - this was for debugging
//	  return Color(hex: hex) // Use the original color if it's not too dark
   }
}
