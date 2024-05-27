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
	  VStack(spacing: 0) {
		 HStack(alignment: .center) {
			VStack(spacing: -4) {  // Remove spacing between VStack elements

			   HStack(spacing: -4) {
				  Spacer()
				  HStack {
					 Text("\(visitors ?? "")")
						.font(.system(size: 35))
						.foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
						.frame(width: 150, alignment: .trailing)
						.lineLimit(1)
						.minimumScaleFactor(0.5)
				  }
				  HStack {
					 Text("vs")
						.font(.footnote)
						.padding(.vertical, 2)
						.frame(width: 40)
				  }

				  HStack {
					 Text("\(home ?? "")")
						.font(.system(size: 35))
						.foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
						.frame(width: 150, alignment: .leading)
						.lineLimit(1)
						.minimumScaleFactor(0.5)
				  }
				  Spacer()
			   }

			   if (inningTxt?.contains("Scheduled") ?? false || inningTxt?.contains("Final") ?? false ) &&  !isToday {
				  Text("\nScheduled: \(startTime ?? "")")
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
					 outsView(outs: eventOuts ?? 0 )
						.frame(width: UIScreen.main.bounds.width, height: 20)
						.padding(.top, 6)
						.font(.system(size: 11))
				  }
			   }

			   Button(action: {
				  refreshGame.toggle() // Toggle the state of refreshGame on click
			   }) {
				  Text("\(refreshGame ? "Updating" : "Not Updating") - \(numUpdates)\n")
					 .foregroundColor(refreshGame ? .green : .red) // Change color based on refreshGame
					 .font(.caption) // Set the font size
					 .frame(width: 220, height: 22, alignment: .trailing) // Frame for the text, right aligned
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

