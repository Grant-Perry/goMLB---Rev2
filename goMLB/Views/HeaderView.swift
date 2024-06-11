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
   @ObservedObject var gameViewModel = GameViewModel()

   @Binding var selectedEventID: String? // Make it a binding

   var event: gameEvent
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
   @Binding var numUpdates: Int
   @Binding var timeRemaining: Int
   var thisIsInProgress: Bool
   var thisMaxUpdates: Int { GameViewModel().maxUpdates}

   var body: some View {
	  VStack(alignment: .leading, spacing: 0) { // Main VStack for all content, left-aligned
		 HStack(alignment: .center) { // Center align the HStack for the matchup
			Spacer() // Push content to the center
			Text(visitors ?? "Visitor")
			   .font(.system(size: 25, weight: .bold))
			   .foregroundColor(.white)
//			   .foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
			Text("vs.")
			   .font(.system(size: 14))
			   .foregroundColor(.gray)
			   .padding(.horizontal, 10) // Add horizontal padding around "vs."
			Text(home ?? "Home")
			   .font(.system(size: 25, weight: .bold))
			   .foregroundColor(.white)
//			   .foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
			Spacer() // Push content to the center
		 }
		 .padding(.horizontal) // Add horizontal padding to the entire HStack

		 HStack(alignment: .top) { // Align to the top for the updating text
			Spacer() // Push the updating text to the right
			VStack(alignment: .trailing, spacing: 0) {
			   if event.isInProgress { // Only show inning text if the game is in progress
				  Text(inningTxt ?? "Inning")
					 .font(.system(size: 12))
					 .foregroundColor(.white)
			   }

//			   Button("Fav Team") {
//				  // Call the function to load games for the favorite team
//				  gameViewModel.loadFavoriteTeamGames()
//				  // Update the selectedEventID to the first game of the favorite team
//				  selectedEventID = gameViewModel.filteredEvents.first?.id.uuidString
//			   }
//			   .font(.footnote)
//			   .padding(4)
//			   .background(Color.blue)
//			   .foregroundColor(.white)
//			   .clipShape(Capsule())

			   // Button to toggle refreshGame and update text
			   Button(action: {
				  if event.isInProgress { // Only allow toggling if game is in progress
					 refreshGame.toggle()
				  }
//				  else {
//					 refreshGame = false // turn off updating if not live game
//				  }
			   }) {
				  HStack {
					 Text(refreshGame ? "Update in: \(timeRemaining) of" : "Not Updating")
						.font(.system(size: 12))
						.foregroundColor(.pink)

					 if refreshGame {
						Button(action: {
						   numUpdates = 0
						}) {
						   Text("\(thisMaxUpdates - numUpdates)")
							  .padding(.trailing)
							  .font(.system(size: 12))
							  .foregroundColor(.pink)
						}
					 }
				  }
//				  Text(refreshGame ? "Update in: \(timeRemaining) of \(thisMaxUpdates - numUpdates)" : "Not Updating")
//					 .font(.system(size: 12))
//					 .foregroundColor(.pink)
			   }
			}
		 }
		 .padding(.horizontal) // Add horizontal padding to the updating text

		 HStack { // HStack for outs and updates
//			Text("\(eventOuts ?? 0)")
//			   .font(.caption)
//			   .foregroundColor(Color(UIColor.lightGray))

			if isToday {
			   Text("Today's Game")
				  .font(.caption)
				  .foregroundColor(.green)
			}

			Spacer()

		 }
		 .padding(.horizontal)
		 .padding(.top, 4)
	  }
	  .padding(.vertical, 8)
	  .background(
		 RoundedRectangle(cornerRadius: 12)
			.fill(Color(uiColor: .secondarySystemBackground))
	  )
//	  .onAppear {
//		 // Set refreshGame to false when the view appears if the game is not in progress
//		 if !event.isInProgress {
//			refreshGame = false
//		 }
//	  }
   }

   func getColorForUI(hex: String, thresholdHex: String) -> Color {
	  return Color(hex: hex) // This can be replaced with your existing implementation
   }
}



//#Preview {
//   HeaderView(
//	  thisIsInProgress: true,
//	  visitors: "Yankees",
//	  home: "Red Sox",
//	  visitColor: "#FFFFFF",
//	  homeColor: "#000000",
//	  inningTxt: "Top 3rd",
//	  startTime: "7:05 PM",
//	  tooDark: "#bababa",
//	  isToday: false,
//	  eventOuts: 2,
//	  refreshGame: .constant(false),
//	  numUpdates: .constant(1),
//	  timeRemaining: .constant(15))
//
//}
//
