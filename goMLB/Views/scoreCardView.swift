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
   private var homeWin: Bool { (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) }
   private var visitWin: Bool { (Int(visitScore) ?? 0) <= (Int(homeScore) ?? 0) }
   private var inningTxt: String? { vm.filteredEvents.first?.inningTxt }
   private var startTime: String? { vm.filteredEvents.first?.startTime }
   private var atBat: String? { vm.filteredEvents.first?.atBat }
   private var atBatPic: String? { vm.filteredEvents.first?.atBatPic }
   private var winColor: Color { .green }
   private var liveAction: Bool { true }

   //   ScoreCardView(visitors: visitors, visitColor: visitColor, titleSize: titleSize, tooDark: tooDark)

   fileprivate func headerView() -> some View {
	  return VStack(spacing: 0) {
		 
		 HStack(alignment: .center) {
			VStack(spacing: -4) {  // Remove spacing between VStack elements
			   
			   HStack(spacing: -4) {
				  Spacer()
				  HStack {
					 Text("\(visitors ?? "")")
						.font(.system(size: titleSize))
						.foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
						.frame(width: 150, alignment: .trailing)
						.lineLimit(1)
						.minimumScaleFactor(0.5)
				  }
				  HStack {
					 Text("vs")
						.font(.footnote)
					 //									  .multilineTextAlignment(.center)
						.padding(.vertical, 2)
						.frame(width: 40)
				  }
				  
				  HStack {
					 Text("\(home ?? "")")
						.font(.system(size: titleSize))
						.foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
						.frame(width: 150, alignment: .leading)
						.lineLimit(1)
						.minimumScaleFactor(0.5)
					 
				  }
				  Spacer()
			   }
			   
			   if (inningTxt?.contains("Scheduled") ?? false ) {
				  Text("\nStarting: \(startTime ?? "")")
					 .font(.system(size: 14))
					 .foregroundColor(.white)
			   }
			   else {
				  Text("\(inningTxt ?? "")")
					 .font(.system(size: 14))
					 .foregroundColor(.white)
					 .padding(.top, 5)
			   }
			   
			   // MARK: Outs view
			   
			   if let lowerInningTxt = inningTxt {
				  if lowerInningTxt.contains("Top") || lowerInningTxt.contains("Bot")  {
					 outsView(outs: event.outs ?? 0 )
						.frame(width: UIScreen.main.bounds.width, height: 20)
						.padding(.top, 6)
						.font(.system(size: 11))
				  }
			   }
			   
			   Button(action: {
				  refreshGame.toggle() // Toggle the state of refreshGame on click
			   }) {
				  Text((refreshGame ? "Updating" : "Not Updating") + "\n")
					 .foregroundColor(refreshGame ? .green : .red) // Change color based on refreshGame
					 .font(.caption) // Set the font size
					 .frame(width: 200, height: 22, alignment: .trailing) // Frame for the text, right aligned
					 .padding(.trailing) // Padding inside the button to the right
				  
				  if refreshGame {
					 timerRemaingView(timeRemaining: $timeRemaining)
						.font(.system(size: 20))
						.frame(width: 200, height: 11, alignment: .trailing) // Frame for the text, right aligned
						.padding(.top, -17)
				  }
			   }
			   .frame(maxWidth: .infinity, alignment: .trailing) // Ensure the button itself is right-aligned
			   .padding(.trailing, 20) // Padding from the right edge of the container
			   .cornerRadius(10) // Rounded corners for the button
			}
			.multilineTextAlignment(.center)
			.padding()
			.lineSpacing(0)
		 }
		 .frame(width: UIScreen.main.bounds.width, height: 200)
		 .minimumScaleFactor(0.25)
		 .scaledToFit()
	  }
	  
	  .frame(width: UIScreen.main.bounds.width, height: 120, alignment: .trailing)
	  .cornerRadius(10)
   }
   
   var body: some View {
	  VStack {


			headerView()
//		 }  // end title section
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
						.frame(width: 110, alignment: .leading)
						.foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
					 //							  .border(.red)

					 Text("\(visitorRecord ?? "")")
						.font(.caption)
						.foregroundColor(.gray)
					 Spacer()
				  }
				  VStack {
					 HStack { // Aligns content to the trailing edge (right)
						Spacer()
						TeamIconView(teamColor: visitColor ?? "C4CED3", teamIcon: event.visitorLogo)
						   .clipShape(Circle())
					 }
					 .frame(width: 90, alignment: .leading)
				  }
			   }
			   // MARK: Visitor Score
			   Text("\(visitScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .padding(.trailing)
				  .foregroundColor(visitWin && Int(visitScore) ?? 0 > 0 ? winColor : Color(hex: visitColor!))
			} // end Visitor Side
			.frame(maxWidth: .infinity, alignment: .trailing)
			//				  .border(.green)

			// MARK: HOME (right) side
			HStack { // Home side
			   Text("\(homeScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .padding(.leading)
				  .foregroundColor(homeWin && Int(homeScore) ?? 0 > 0 ? winColor : Color(hex: homeColor!))


			   VStack(alignment: .leading) {
				  VStack {
					 Text("\(home ?? "")")
						.font(.title3)
						.foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
						.minimumScaleFactor(0.5)
						.lineLimit(1)

					 Text("\(vm.filteredEvents.first?.homeRecord ?? "")")
						.font(.caption)
						.foregroundColor(.gray)
				  }

				  VStack {
					 HStack { // Aligns content to the trailing edge (right)
							  //							  Spacer()
						TeamIconView(teamColor: homeColor ?? "C4CED3", teamIcon: event.homeLogo)
						   .clipShape(Circle())
					 }
					 .frame(width: 90, alignment: .trailing)
					 //						   .border(.green)
				  }
			   }

			} // end Home side
			.frame(maxWidth: .infinity, alignment: .leading)
			//				  .border(.red)

		 } // end Visitor Home sides
		 .frame(width: UIScreen.main.bounds.width, height: 110)
		 //			   .border(.blue)


	  }  // full card
	  .frame(width: UIScreen.main.bounds.width  * 0.9, height: .infinity)
   }
}

//#Preview {
//    scoreCardView()
//}
