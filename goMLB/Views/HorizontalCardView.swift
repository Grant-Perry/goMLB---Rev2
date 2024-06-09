//   HorizontalCardView.swift
//   goMLB
//
//   Created by: Grant Perry on 6/8/24 at 11:03 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct HorizontalCardView: View {
   @ObservedObject var gameViewModel: GameViewModel
   var event: gameEvent
   let teamSize: CGFloat
   let teamScoreSize: CGFloat

   var body: some View {
	  VStack(spacing: 0) {
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
				  .font(.system(size:teamSize, weight: .bold))
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
			   if event.isInProgress {
				  BasesView(onFirst: event.on1,
							onSecond: event.on2,
							onThird: event.on3,
							strikes: event.strikes ?? 0,
							balls: event.balls ?? 0,
							outs: event.outs ?? 0,
							inning: event.inning,
							inningTxt: event.inningTxt,
							thisSubStrike: event.thisSubStrike,
							atBat: event.atBat,
							atBatPic: event.atBatPic,
							showPic: false,
							batterStats: event.batterStats,
							batterLine: event.batterLine)
				  .scaleEffect(0.55)
				  .frame(width: 40, height: 20)
				  .padding(.top, 20)
			   } else {
				  Text(event.inningTxt.contains("Final") ? "Final" : "")
					 .frame(width: 40, height: 20)
					 .font(.footnote)
					 .foregroundColor(.white)
					 .frame(maxWidth: .infinity)
					 .lineLimit(1)
					 .minimumScaleFactor(0.5)
					 .scaledToFit()
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
		 if !event.isInProgress {
			HStack {
			   Text("Next Game: \(event.startTime)")
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
}

