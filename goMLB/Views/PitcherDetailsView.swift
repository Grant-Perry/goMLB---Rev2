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
					 if let pitches = event.currentPitcherPitchesThrown {
						Text("Pitches: \(pitches)")
					 }
				  }
				  .font(.footnote)
				  .foregroundColor(.white)
			   }
			   if let currentPitcherPic = event.currentPitcherPic, let url = URL(string: currentPitcherPic) {
				  AsyncImage(url: url) { phase in
					 switch phase {
						case .empty:
						   ProgressView()
							  .progressViewStyle(CircularProgressViewStyle())
							  .frame(width: picSize)
						case .success(let image):
						   image
							  .resizable()
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
			   } else {
				  Image(systemName: "photo")
					 .resizable()
					 .scaledToFit()
					 .frame(width: picSize)
					 .foregroundColor(.gray)
					 .clipShape(Circle())
			   }
			}
		 }
		 .frame(maxWidth: .infinity)
		 //        .border(.red)

		 // Visitor Pitcher's Info
		 VStack {
			HStack {
			   if let visitorPitcherPic = event.visitorPitcherPic, let url = URL(string: visitorPitcherPic) {
				  AsyncImage(url: url) { phase in
					 switch phase {
						case .empty:
						   ProgressView()
							  .progressViewStyle(CircularProgressViewStyle())
							  .frame(width: picSize)
						case .success(let image):
						   image
							  .resizable()
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
			   } else {
				  Image(systemName: "photo")
					 .resizable()
					 .scaledToFit()
					 .frame(width: picSize)
					 .foregroundColor(.gray)
					 .clipShape(Circle())
			   }

			   VStack(alignment: .leading) {
				  HStack {
					 Text(event.visitorPitcherName)
						.font(.footnote)
						.bold()
						.onTapGesture {
						   if let url = URL(string: event.visitorPitcherBioURL) {
							  UIApplication.shared.open(url)
						   }
						}
					 Text(event.visitorPitcherThrows)
						.font(.footnote)
				  }
				  VStack(alignment: .leading) {
					 Text("ERA: \(event.visitorPitcherERA)")
					 Text("\(event.visitorPitcherWins)-\(event.visitorPitcherLosses) - K: \(event.visitorPitcherStrikeOuts)")
				  }
				  .font(.footnote)
				  .foregroundColor(.white)
			   }
			}
		 }
		 .frame(maxWidth: .infinity)
		 //        .border(.yellow)
	  }
	  .frame(maxWidth: .infinity)
	  .padding()
	  //    .border(.green)
   }
}

