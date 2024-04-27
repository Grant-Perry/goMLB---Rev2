//   basesView.swift
//   goMLB
//
//   Created by: Grant Perry on 4/22/24 at 3:00 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct BasesView: View {
	@Environment(\.colorScheme) var colorScheme
	var eventViewModel: EventViewModel = EventViewModel()
   var onFirst: Bool
   var onSecond: Bool
   var onThird: Bool
   var strikes: Int
   var balls: Int
   var outs: Int
	var inningTxt: String
	var thisSubStrike: Int

   var body: some View {
	  ScrollView {

		 HStack(alignment: .center) {
			 
			GeometryReader { geometry in

			   ZStack {
				  // Top middle (Second base)
					Image(systemName: onSecond ? "diamond.fill" : "diamond")
					 .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)

				  // Bottom left (Third base)
					Image(systemName: onThird ? "diamond.fill" : "diamond")
					 .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.8)

				  // Bottom right (First base)
					Image(systemName: onFirst ? "diamond.fill" : "diamond")
					 .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.8)
				}
			}
			.frame(width: 50, height: 30)
			.padding(10)
		 }
		  VStack(alignment: .center, spacing: 0) {
			  VStack(spacing: 0) {
				  Text("Inning: \(inningTxt)")
					 .font(.caption)
			  }
			  VStack(spacing: 0) {

				  Text("Balls: \(balls) - Strikes: \(strikes)" +
						 "\(thisSubStrike  > 0 ? ".\(thisSubStrike)" : "") - Outs: \(outs)")
			  }
			  .padding(.top)
		  }
	  }
	  .frame(width: UIScreen.main.bounds.width, height: 135)
	  .preferredColorScheme(.dark)
	}
}


struct BasesView_Previews: PreviewProvider {
   static var previews: some View {
		BasesView(onFirst: true, onSecond: false, onThird: true, strikes: 1, balls: 3, outs: 2, inningTxt: "Top 3rd", thisSubStrike: 2)
		 .frame(width: 300, height: 300)
   }
}

