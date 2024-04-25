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
   var onFirst: Bool
   var onSecond: Bool
   var onThird: Bool
   var strikes: Int
   var balls: Int
   var outs: Int
	var inningTxt: String

   var body: some View {
	  ScrollView {

		 HStack(alignment: .center) {
			GeometryReader { geometry in
			   let size = min(geometry.size.width, geometry.size.height) / 2
			   let strokeWidth: CGFloat = 2
			   let onBaseColor: Color = .green
			   let strokeColor: Color = .black

			   ZStack {
				  // Top middle (Second base)
				  Circle()
					 .fill(onSecond ? onBaseColor : Color.clear)
					 .frame(width: size, height: size)
					 .overlay(
						Circle()
						   .stroke(!onSecond ? strokeColor : strokeColor, lineWidth: onSecond ? strokeWidth : strokeWidth)
					 )
					 .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)

				  // Bottom left (Third base)
				  Circle()
					 .fill(onThird ? onBaseColor : Color.clear)
					 .frame(width: size, height: size)
					 .overlay(
						Circle()
						   .stroke(!onThird ? strokeColor : strokeColor, lineWidth: onFirst ? strokeWidth : strokeWidth)
					 )
					 .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.8)

				  // Bottom right (First base)
				  Circle()
					 .fill(onFirst ? onBaseColor : Color.clear)
					 .frame(width: size, height: size)
					 .overlay(
						Circle()
							.stroke(!onFirst ? strokeColor : strokeColor, lineWidth: onThird ? strokeWidth : strokeWidth)
					 )
					 .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.8)
				}
			}
			.frame(width: 40, height: 30)
		 }

		  VStack(alignment: .center, spacing: 0) {
		 	 VStack {
				  Text("Inning: \(inningTxt)")
					  .font(.caption)
			  }
			  VStack {
				  Text("\nBalls: \(balls) - Strikes: \(strikes) - Outs: \(outs) ")
			  }
			  Spacer()
		  }
	  }
	  .frame(width: UIScreen.main.bounds.width, height: 125)
	  .preferredColorScheme(.light)
	}
}

struct BasesView_Previews: PreviewProvider {
   static var previews: some View {
		BasesView(onFirst: true, onSecond: false, onThird: true, strikes: 1, balls: 3, outs: 2, inningTxt: "Top 3rd")
		 .frame(width: 300, height: 300)
   }
}

