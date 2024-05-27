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
//   var visitorRecord: Int

   @Binding var refreshGame: Bool

   @Binding var timeRemaining: Int
//   @Binding var fakeTimer: Int

   // Computed properties to handle dynamic content
   private var home: String? { vm.filteredEvents.first?.home }
   private var homeScore: String { vm.filteredEvents.first?.homeScore ?? "0" }
   private var homeRecord: String? { vm.filteredEvents.first?.homeRecord}
   private var visitorRecord: String? { vm.filteredEvents.first?.visitorRecord}
   private var homeColor: String? { vm.filteredEvents.first?.homeColor }
   private var visitors: String? { vm.filteredEvents.first?.visitors }
   private var visitScore: String { vm.filteredEvents.first?.visitScore ?? "0" }
   private var visitColor: String? { vm.filteredEvents.first?.visitorAltColor }
   private var homeWin: Bool { (Int(visitScore) ?? 0) < (Int(homeScore) ?? 0) }
   private var visitWin: Bool { (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) }
   private var inningTxt: String? { vm.filteredEvents.first?.inningTxt }
   private var startTime: String? { event.startTime }
   private var atBat: String? { vm.filteredEvents.first?.atBat }
   private var atBatPic: String? { vm.filteredEvents.first?.atBatPic }
   private var winColor: Color { .green }

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
				  numUpdates: $numUpdates
			   )
			}

			// MARK: Scores card
			HStack(spacing: 0) {
				// MARK: Visitor's Side
				HStack { // Visitor Side
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
				} // end Visitor Side
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

				// MARK: HOME (right) side
				HStack { // Home side
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
//								.border(.red)


							Text("\(vm.filteredEvents.first?.homeRecord ?? "")")
								.font(.caption)
								.foregroundColor(.gray)
								.frame(maxWidth: .infinity, alignment: .leading)

						   HStack {
							  TeamIconView(teamColor: homeColor ?? "C4CED3", teamIcon: event.homeLogo)
								 .clipShape(Circle())
						   }
						   //							.frame(width: 90, alignment: .leading)
						   .frame(maxWidth: .infinity, alignment: .center)
						   .padding(.bottom, 2)

						}
					}

				} // end Home side

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
		}  // full card
		.frame(width: UIScreen.main.bounds.width * 0.9)  //, height: .infinity)
		.padding(.bottom, 50) // MAAAYYYbe adjust this?

	}

}

//#Preview {
//    scoreCardView()
//}
