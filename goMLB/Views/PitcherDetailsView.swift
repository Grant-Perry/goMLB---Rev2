//   PitcherDetailsView.swift
//   goMLB
//
//   Created by: Grant Perry on 6/14/24 at 7:01 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

// PitcherDetailsView.swift
import SwiftUI

struct PitcherDetailsView: View {
   var event: gameEvent
   var picSize: CGFloat = 75.0

   var body: some View {
	  HStack(spacing: 0) {
		 // Current Pitcher's Info
		 VStack {
			HStack {
			   VStack(alignment: .trailing) {
				  HStack {
					 Text(event.currentPitcherThrows)
						.font(.footnote)
					 Text(event.currentPitcherName)
						.font(.footnote)
						.bold()
						.onTapGesture {
						   if let url = URL(string: event.currentPitcherBioURL) {
							  UIApplication.shared.open(url)
						   }
						}
				  }
				  VStack(alignment: .trailing) {
					 Text("ERA: \(event.currentPitcherERA)")
					 Text("\(event.currentPitcherWins)-\(event.currentPitcherLosses) - K: \(event.currentPitcherStrikeOuts)")
				  }
				  .font(.footnote)
				  .foregroundColor(.white)
			   }
			   AsyncImage(url: URL(string: event.currentPitcherPic)) { phase in
				  switch phase {
					 case .empty:
						ProgressView()
						   .progressViewStyle(CircularProgressViewStyle())
						   .frame(width: picSize)
					 case .success(let image):
						image.resizable()
						   .scaledToFit()
						   .frame(width:picSize)
						   .clipShape(Circle())
					 case .failure:
						Image(systemName: "photo")
						   .resizable()
						   .scaledToFit()
						   .frame(width: picSize)
						   .foregroundColor(.gray)
						   .clipShape(Circle())
					 @unknown default:
						EmptyView()
				  }
			   }
			}
		 }
		 .frame(maxWidth: .infinity)
//		 .border(.red)

		 // Home Pitcher's Info
		 VStack {
			HStack {
			   AsyncImage(url: URL(string: event.homePitcherPic)) { phase in
				  switch phase {
					 case .empty:
						ProgressView()
						   .progressViewStyle(CircularProgressViewStyle())
						   .frame(width: picSize)
					 case .success(let image):
						image.resizable()
						   .scaledToFit()
						   .frame(width: picSize)
						   .clipShape(Circle())
					 case .failure:
						Image(systemName: "photo")
						   .resizable()
						   .scaledToFit()
						   .frame(width: picSize)
						   .foregroundColor(.gray)
						   .clipShape(Circle())
					 @unknown default:
						EmptyView()
				  }
			   }
			   VStack(alignment: .leading) {
				  HStack {
					 Text(event.homePitcherName)
						.font(.footnote)
						.bold()
						.onTapGesture {
						   if let url = URL(string: event.homePitcherBioURL) {
							  UIApplication.shared.open(url)
						   }
						}
					 Text(event.homePitcherThrows)
						.font(.footnote)
				  }
				  VStack(alignment: .leading) {
					 Text("ERA: \(event.homePitcherERA)")
					 Text("\(event.homePitcherWins)-\(event.homePitcherLosses) - K: \(event.homePitcherStrikeOuts)")
				  }
				  .font(.footnote)
				  .foregroundColor(.white)
			   }
			}
		 }
		 .frame(maxWidth: .infinity)
//		 .border(.yellow)
	  }
	  .frame(maxWidth: .infinity)
	  .padding()
//	  .border(.green)
   }
}
