//   HeaderView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/26/24 at 8:31 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

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
   @Binding var showModal: Bool
   @State private var selectedTeam: String?
   @Binding var selectedEventID: String?
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
   var thisMaxUpdates: Int { GameViewModel().maxUpdates }

   var body: some View {
	  VStack(alignment: .leading, spacing: 0) {
		 HStack(alignment: .center) {
			Spacer()

			ZStack {
			   Text(visitors ?? "Visitor")
				  .font(.system(size: 25, weight: .bold))
				  .foregroundColor(.white)
				  .onTapGesture {
					 selectedTeam = visitors
					 showModal = true
				  }
			   if gameViewModel.favTeam == visitors {
				  Image(systemName: "star.fill")
					 .resizable()
					 .frame(width: 10, height: 10)
					 .foregroundColor(.yellow)
					 .offset(x: 55, y: -10)
			   }
			}

			Text("vs.")
			   .font(.system(size: 14))
			   .foregroundColor(.gray)
			   .padding(.horizontal, 10)

			ZStack {
			   Text(home ?? "Home")
				  .font(.system(size: 25, weight: .bold))
				  .foregroundColor(.white)
				  .onTapGesture {
					 selectedTeam = home
					 showModal = true
				  }
			   if gameViewModel.favTeam == home {
				  Image(systemName: "star.fill")
					 .resizable()
					 .frame(width: 10, height: 10)
					 .foregroundColor(.yellow)
					 .offset(x: 55, y: -10)
			   }
			}
			Spacer()
		 }
		 .padding(.horizontal)

		 HStack(alignment: .top) {
			Spacer()
			VStack(alignment: .trailing, spacing: 0) {
			   if event.isInProgress {
				  Text(inningTxt ?? "Inning")
					 .font(.system(size: 12))
					 .foregroundColor(.white)
			   }

			   HStack {
				  Text(refreshGame ? "Update in: \(timeRemaining) of" : "Not Updating")
					 .font(.system(size: 12))
					 .foregroundColor(.pink)
					 .onTapGesture {
						if event.isInProgress {
						   refreshGame.toggle()
						}
					 }

				  if refreshGame {
					 Text("\(thisMaxUpdates - numUpdates)")
						.padding(.trailing)
						.font(.system(size: 12))
						.foregroundColor(.pink)
						.onTapGesture {
						   numUpdates = 0
						}
				  }
			   }
			}
		 }
		 .padding(.horizontal)

		 HStack {
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
	  .sheet(isPresented: $showModal) {
		 ConfirmationSheet(
			selectedTeam: $selectedTeam,
			gameViewModel: gameViewModel
		 )
	  }
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

