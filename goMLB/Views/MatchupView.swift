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
							  .font(.system(size: 16, weight: .bold))
							  .foregroundColor(.white)
						   Spacer()
						}
						HStack {
						   Spacer()
						   Text(event.home)
							  .font(.system(size: 16, weight: .bold))
							  .foregroundColor(.white)
						   Spacer()
						}
					 }
					 VStack {
						HStack {
						   Spacer()
						   Text(event.visitScore)
							  .font(.system(size: 14))
							  .foregroundColor(.white)
						   Spacer()
						}
						HStack {
						   Spacer()
						   Text(event.homeScore)
							  .font(.system(size: 14))
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





