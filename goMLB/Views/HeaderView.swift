//   HeaderView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/26/24 at 8:31 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct HeaderView: View {
   var visitors: String?
   var home: String?
   var visitColor: String?
   var homeColor: String?
   var inningTxt: String?
   var startTime: String?
   var tooDark: String
   var isToday: Bool
   var eventOuts: Int?
   @Binding var refreshGame: Bool
   @Binding var timeRemaining: Int
   @Binding var numUpdates: Int

   var body: some View {
	  VStack(alignment: .leading, spacing: 0) { // Align items to the leading edge and remove default spacing
		 HStack(alignment: .top) { // Align items to the top in the HStack
			VStack(alignment: .leading) { // Left-aligned team names
			   Text(visitors ?? "Visitor")
				  .font(.system(size: 18, weight: .bold))
				  .foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
			   Text(home ?? "Home")
				  .font(.system(size: 18, weight: .bold))
				  .foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
			}

			Spacer() // Push elements to the sides

			VStack(alignment: .trailing) { // Right-aligned time/inning
			   HStack(spacing: 0) { // Remove space between text and number
				  Text("Middle ") // Hardcode "Middle" based on screenshot
					 .font(.system(size: 12))
					 .foregroundColor(.gray)
				  Text(inningTxt?.last?.wholeNumberValue.map(String.init) ?? "")
					 .font(.system(size: 12))
					 .foregroundColor(.gray)
			   }
			   Text("Updating in \(timeRemaining)") // Display "Updating in" text
				  .font(.system(size: 12))
				  .foregroundColor(.orange)
			}
		 }
		 .padding(.horizontal) // Add horizontal padding only

		 HStack { // Second row for "Outs" and "Today's Game"
			Text("\(eventOuts ?? 0)")
			   .font(.caption)
			   .foregroundColor(Color(UIColor.lightGray)) // Light gray color

			if isToday {
			   Text("Today's Game")
				  .font(.caption)
				  .foregroundColor(.green)
			}

			Spacer()

			Text("Updates: \(numUpdates)")
			   .font(.caption)
			   .foregroundColor(Color(UIColor.lightGray)) // Light gray color
		 }
		 .padding(.horizontal) // Add horizontal padding only
		 .padding(.top, 4) // Add slight top padding
	  }
	  .padding(.vertical, 8) // Add vertical padding for top and bottom
	  .background(
		 RoundedRectangle(cornerRadius: 12)
			.fill(Color(uiColor: .secondarySystemBackground))
	  )
   }

   func getColorForUI(hex: String, thresholdHex: String) -> Color {
	  return Color(hex: hex)
   }
}

#Preview {
   HeaderView(
	  visitors: "Yankees",
	  home: "Red Sox",
	  visitColor: "#FFFFFF",
	  homeColor: "#000000",
	  inningTxt: "Top 3rd",
	  startTime: "7:05 PM",
	  tooDark: "#bababa",
	  isToday: false,
	  eventOuts: 2,
	  refreshGame: .constant(false),
	  timeRemaining: .constant(15),
	  numUpdates: .constant(1)
   )
}

