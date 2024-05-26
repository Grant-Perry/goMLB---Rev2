//   HorizontalMatchupView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/25/24 at 6:05 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//


import SwiftUI

struct MatchupView: View {
//   @ObservedObject var gameViewModel: GameViewModel
   var gameViewModel: GameViewModel
   @Binding var selectedEventID: String?
   var teamSize = 20.0
   var teamScoreSize = 18.0

   var body: some View {
	  ScrollView(.horizontal, showsIndicators: false) {
		 HStack(spacing: 10) {
			ForEach(gameViewModel.allEvents, id: \.ID) { event in
			   Button(action: {
				  selectedEventID = event.ID.uuidString
				  gameViewModel.updateTeamPlaying(with: event.visitors)
				  gameViewModel.teamPlaying = event.visitors
			   }) {
				  VStack {
					 VStack {
						HStack {
						   Spacer()
						   Text(event.visitors)
							  .font(.system(size: teamSize, weight: .bold))
							  .foregroundColor(.white)
							  .lineLimit(1)
							  .minimumScaleFactor(0.45)
							  .scaledToFit()
						   Spacer()
						}
						HStack {
						   Spacer()
						   Text(event.home)
							  .font(.system(size: teamSize, weight: .bold))
							  .foregroundColor(.white)
							  .lineLimit(1)
							  .minimumScaleFactor(0.45)
							  .scaledToFit()
						   Spacer()
						}
					 }
					 VStack {
						HStack {
						   Spacer()
						   Text(event.visitScore)
							  .font(.system(size: teamScoreSize))
							  .foregroundColor(.white)
						   Spacer()
						}
						HStack {
						   Spacer()
						   Text(event.homeScore)
							  .font(.system(size: teamSize))
							  .foregroundColor(.white)
						   Spacer()
						}
					 }
				  }
				  .frame(width: 165, height: 60)
				  .background(.blue.gradient)
				  .cornerRadius(10)
				  .opacity(0.8)
			   }
			   .buttonStyle(PlainButtonStyle())
			}
		 }
		 .padding(.horizontal)
	  }
	  .padding()
   }
}





