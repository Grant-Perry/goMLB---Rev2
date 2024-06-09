//   scoreCardView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/10/24 at 1:24 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct scoreCardView: View {
   var vm: GameViewModel
   var titleSize: CGFloat
   var tooDark: String
   var event: gameEvent
   var scoreSize: Int
   @Binding var numUpdates: Int
   @Binding var refreshGame: Bool
   @Binding var timeRemaining: Int

   let home: String?
   let homeScore: String
   let homeRecord: String?
   let visitorRecord: String?
   let homeColor: String?
   let visitors: String?
   let visitScore: String
   let visitColor: String?
   let homeWin: Bool
   let visitWin: Bool
   let inningTxt: String?
   let startTime: String?
   let atBat: String?
   let atBatPic: String?
   let batterStats: String?
   let batterLine: String?
   var winColor: Color { .green }

   init(vm: GameViewModel, titleSize: CGFloat, tooDark: String, event: gameEvent, scoreSize: Int, numUpdates: Binding<Int>, refreshGame: Binding<Bool>, timeRemaining: Binding<Int>) {
	  self.vm = vm
	  self.titleSize = titleSize
	  self.tooDark = tooDark
	  self.event = event
	  self.scoreSize = scoreSize
	  self._numUpdates = numUpdates
	  self._refreshGame = refreshGame
	  self._timeRemaining = timeRemaining

	  // Initialize let properties here
	  if let firstEvent = vm.filteredEvents.first {
		 self.home = firstEvent.home
		 self.homeScore = firstEvent.homeScore
		 self.homeRecord = firstEvent.homeRecord
		 self.visitorRecord = firstEvent.visitorRecord
		 self.homeColor = firstEvent.homeColor
		 self.visitors = firstEvent.visitors
		 self.visitScore = firstEvent.visitScore
		 self.visitColor = firstEvent.visitorAltColor
		 self.inningTxt = firstEvent.inningTxt
		 self.atBat = firstEvent.atBat
		 self.atBatPic = firstEvent.atBatPic
		 self.batterStats = firstEvent.batterStats
		 self.batterLine = firstEvent.batterLine
	  } else {
		 // Set default values if filteredEvents is empty
		 self.home = nil
		 self.homeScore = "0"
		 self.homeRecord = nil
		 self.visitorRecord = nil
		 self.homeColor = nil
		 self.visitors = nil
		 self.visitScore = "0"
		 self.visitColor = nil
		 self.inningTxt = nil
		 self.atBat = nil
		 self.atBatPic = nil
		 self.batterStats = nil
		 self.batterLine = nil
	  }
	  self.startTime = event.startTime
	  self.homeWin = (Int(visitScore) ?? 0) < (Int(homeScore) ?? 0)
	  self.visitWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0)
   }

   var body: some View {
	  VStack {
		 VStack {
			HeaderView(
			   visitors: visitors,
			   home: home,
			   visitColor: visitColor,
			   homeColor: homeColor,
			   inningTxt: inningTxt,
			   startTime: startTime,
			   tooDark: tooDark,
			   isToday: vm.isToday,
			   eventOuts: event.outs,
			   refreshGame: $refreshGame,
			   timeRemaining: $timeRemaining,
			   numUpdates: $numUpdates)
		 }

		 // MARK: Scores card
		 HStack(spacing: 0) {
			// MARK: Visitor's Side
			HStack {
			   VStack(alignment: .leading, spacing: 0) {
				  VStack {
					 Text("\(visitors ?? "")")
						.font(.title3)
						.minimumScaleFactor(0.5)
						.lineLimit(1)
						.frame(maxWidth: .infinity, alignment: .trailing)
						.foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))

					 Text("\(visitorRecord ?? "")")
						.font(.caption)
						.padding(.trailing, 5)
						.foregroundColor(.gray)
						.frame(maxWidth: .infinity, alignment: .trailing)

					 HStack {
						TeamIconView(teamColor: visitColor ?? "C4CED3", teamIcon: event.visitorLogo)
						   .clipShape(Circle())
					 }
					 .frame(maxWidth: .infinity, alignment: .center)
					 .padding(.bottom, 2)
				  }
			   }
			   // MARK: Visitor Score
			   Text("\(visitScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .padding(.trailing)
				  .foregroundColor(visitWin && Int(visitScore) ?? 0 > 0 ? winColor : Color(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark)))
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			.background(
			   Group {
				  if visitWin, Int(visitScore) ?? 0 > 0 {
					 LinearGradient(
						gradient: Gradient(colors: [Color.clear, Color.green.opacity(0.5)]),
						startPoint: .trailing,
						endPoint: .leading
					 )
				  } else {
					 Color.clear
				  }
			   }
			)

			// MARK: Home Side
			HStack {
			   Text("\(homeScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .padding(.leading)
				  .foregroundColor(homeWin && Int(homeScore) ?? 0 > 0 ? winColor : Color(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark)))

			   VStack(alignment: .leading) {
				  VStack {
					 Text("\(home ?? "")")
						.font(.title3)
						.foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
						.minimumScaleFactor(0.5)
						.frame(maxWidth: .infinity, alignment: .leading)
						.lineLimit(1)

					 Text("\(vm.filteredEvents.first?.homeRecord ?? "")")
						.font(.caption)
						.foregroundColor(.gray)
						.frame(maxWidth: .infinity, alignment: .leading)

					 HStack {
						TeamIconView(teamColor: homeColor ?? "C4CED3", teamIcon: event.homeLogo)
						   .clipShape(Circle())
					 }
					 .frame(maxWidth: .infinity, alignment: .center)
					 .padding(.bottom, 2)
				  }
			   }
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(
			   Group {
				  if homeWin, Int(homeScore) ?? 0 > 0 {
					 LinearGradient(
						gradient: Gradient(colors: [Color.clear, Color.green.opacity(0.5)]),
						startPoint: .leading,
						endPoint: .trailing
					 )
				  } else {
					 Color.clear
				  }
			   }
			)
		 } // end Visitor Home sides

		 if let atBat = atBat, !atBat.isEmpty {
			VStack {
			   Text("At Bat: \(atBat)")
				  .font(.headline)
			   if let batterStats = batterStats {
				  Text("Stats: \(batterStats)")
					 .font(.subheadline)
			   }
			   if let batterLine = batterLine {
				  Text("Line: \(batterLine)")
					 .font(.subheadline)
			   }
			}
			.padding()
			.foregroundColor(.white)
		 }
	  }
	  .frame(width: UIScreen.main.bounds.width * 0.9)
	  .padding(.bottom, 50)
   }
}


//#Preview {
//    scoreCardView()
//}
