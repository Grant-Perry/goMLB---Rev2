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
   @ObservedObject var gameViewModel: GameViewModel
   @Binding var selectedEventID: String?
   var teamSize: CGFloat
   var teamScoreSize: CGFloat
   var cardColor: Color

   var body: some View {
	  ScrollView(.horizontal, showsIndicators: false) {
		 HStack(spacing: 10) {
			ForEach(gameViewModel.allEvents, id: \.ID) { event in
			   let vm = gameViewModel.filteredEvents.first
			   let atBat = vm?.atBat
			   let atBatPic = vm?.atBatPic

			   var liveAction: Bool {
				  if event.inningTxt.contains("Final") || event.inningTxt.contains("Scheduled") {
					 return false
				  } else {
					 return true
				  }
			   }
			   Button(action: {
				  selectedEventID = event.ID.uuidString
				  gameViewModel.updateTeamPlaying(with: event.visitors)
				  gameViewModel.teamPlaying = event.visitors
			   }) {
				  VStack(spacing: 0) {
//					 if !liveAction {
//						HStack {
//						   Text("\(event.startTime) start")
//							  .font(.system(size: 12, weight: .bold))
//							  .frame(maxWidth: .infinity, alignment: .top)
//							  .padding(.top, -8)
//						}
//					 }
					 HStack(spacing: 3) {
						HStack {
						   Text(event.visitors)
							  .font(.system(size: teamSize, weight: .bold))
							  .foregroundColor(.white)
						}
						HStack {
						   Text("vs.")
							  .font(.system(size: 9))
						}
						HStack {
						   Text(event.home)
							  .font(.system(size: teamSize, weight: .bold))
							  .foregroundColor(.white)
						}
					 }
					 HStack {
						HStack {
						   Spacer()
						   Text(event.visitScore)
							  .font(.system(size: teamScoreSize))
							  .foregroundColor(.white)
							  .frame(maxWidth: 40, alignment: .trailing)
						}

						HStack {
						   if liveAction {
							  BasesView(onFirst: event.on1,
										onSecond: event.on2,
										onThird: event.on3,
										strikes: event.strikes ?? 0,
										balls: event.balls ?? 0,
										outs: event.outs ?? 0,
										inning: event.inning,
										inningTxt: event.inningTxt,
										thisSubStrike: event.thisSubStrike,
										atBat: atBat ?? "N/A",
										atBatPic: atBatPic ?? "N/A URL",
										showPic: false)
							  .scaleEffect(0.7)
							  .frame(width: 40, height: 20)
							  .padding(.top, 20)
						   } else {
							  Text("") // space in the middle of the scores
								 .frame(width: 40, height: 20)
						   }
						}

						HStack {
						   Spacer()
						   Text(event.homeScore)
							  .font(.system(size: teamScoreSize))
							  .frame(maxWidth: .infinity, alignment: .leading)
							  .foregroundColor(.white)
						   Spacer()
						}
					 }
					 if !liveAction {
						HStack {
						   Text("Scheduled: \(event.startTime)")
							  .font(.system(size: 12, weight: .bold))
							  .foregroundColor(.white)
							  .frame(maxWidth: .infinity, alignment: .top)
							  .padding(.top, 20)
						}
					 }
				  }
				  .frame(width: 165, height: 120)
				  .background(
					 event.inningTxt.contains("Final") ? Color.indigo.gradient :
						event.inningTxt.contains("Scheduled") ? Color.yellow.gradient :
						Color.blue.gradient
				  )
				  .foregroundColor(.white)
				  .cornerRadius(10)
				  .opacity(0.9)
			   }
			   .buttonStyle(PlainButtonStyle())
			}
		 }
		 .padding()
	  }
	  .frame(maxWidth: .infinity, alignment: .leading)
	  .background(cardColor)
	  .ignoresSafeArea(edges: .bottom)
	  .opacity(0.9)
   }
}




