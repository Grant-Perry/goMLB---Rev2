//   basesView.swift
//   goMLB
//
//   Created by: Grant Perry on 4/22/24 at 3:00 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry

import SwiftUI

struct BasesView: View {

   var onFirst: Bool
   var onSecond: Bool
   var onThird: Bool
   var strikes: Int
   var balls: Int
   var outs: Int
   var inning: Int
   var inningTxt: String
   var thisSubStrike: Int
   var atBat: String
   var atBatPic: String
   var showPic: Bool

   var body: some View {
	  VStack {

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

		 VStack(alignment: .center, spacing: 2) {

			VStack(spacing: 0) {
			   Text("\(balls)-\(strikes)\(thisSubStrike  > 0 ? ".\(thisSubStrike)" : "")")
				  .font(.system(size: 14))
			   //			   Spacer()

			   VStack {
				  outsView(outs: outs)
					 .font(.system(size: 10))
					 .padding(.top, 1)
			   }
			   if showPic { // don't show bottom half if false to use this view in other smaller places
				  Spacer()

// MARK: Inning arrow up/down inning text
				  if !inningTxt.contains("Final") {
				     VStack {
						let thisInning = getInningSymbol(inningTxt: inningTxt)
						HStack(spacing: 0) {
						   Image(systemName: thisInning.rawValue).imageScale(.small)
						   Text("\(inning)")
						}
						.font(.footnote)
						.padding(.top, 3)
						.padding(.bottom, 2)

   //					 Text("\(inningTxt)")
   //						.font(.caption)
					 }
				  }
				  Spacer()

				  // MARK: at bat player card
				  HStack(spacing: 0) {
					 HStack {
						if let url = URL(string: atBatPic) {
						   AsyncImage(url: url) { phase in
							  switch phase {
								 case .empty:
									// While the image is loading (e.g., show an activity indicator or a placeholder image)
									ProgressView()
									   .progressViewStyle(CircularProgressViewStyle())
									   .frame(width: 100, height: 100)

								 case .success(let image):
									// On successful image load
									image.resizable()
									   .scaledToFit()
									   .frame(width: 70)
									   .clipShape(Circle())


								 case .failure:
									// If the image fails to load (e.g., show an error image or a default image)
									Image(systemName: "photo")
									   .resizable()
									   .scaledToFit()
									   .frame(width: 100, height: 100)
									   .foregroundColor(.gray)
									   .clipShape(Circle())


								 @unknown default:
									// Future proofing for additional cases that are not covered
									EmptyView()
							  }
						   }
						} else {
						   // In case the URL is not valid
						   Text("")
						}
					 }

					 HStack {
						Text("\(atBat)")
						   .font(.system(size: 14)) +
						Text("\nat bat")
						   .font(.system(size: 10))
					 }
				  }
			   }
			}
		 }
	  }
	  .frame(width: UIScreen.main.bounds.width, height: 175)
	  .preferredColorScheme(.dark)
   }
}

struct BasesView_Previews: PreviewProvider {
   static var previews: some View {
	  BasesView(onFirst: true,
				onSecond: false,
				onThird: true,
				strikes: 2,
				balls: 3,
				outs: 1,
				inning: 5,
				inningTxt: "Top 5th",
				thisSubStrike: 2,
				atBat: "J. Soto",
				atBatPic: "https://a.espncdn.com/i/headshots/mlb/players/full/31006.png",
				showPic: true)

	  .frame(width: 300, height: 300)
   }
}


