//   teamIconView.swift
//   goMLB
//
//   Created by: Gp. on 4/25/24 at 10:30 AM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct TeamIconView: View {
   var teamColor: String
   var teamIcon: String

   var body: some View {
	  ZStack {
		 Circle()
			.fill(Color(hex: teamColor))
			.frame(width: 50, height: 50)

		 if let url = URL(string: teamIcon) {
			AsyncImage(url: url) { phase in
			   switch phase {
				  case .empty:
					 ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.frame(width: 50, height: 50)

				  case .success(let image):
					 image.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
						.clipShape(Circle())

				  case .failure(let error):
					 // Display an error message or placeholder image
					 Image(systemName: "exclamationmark.triangle.fill") // Example error image
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
						.foregroundColor(.red)
						.clipShape(Circle())

				  @unknown default:
					 // Handle unknown cases (optional)
					 EmptyView()
			   }
			}
		 } else {
			Image(systemName: "photo")
			   .resizable()
			   .scaledToFit()
			   .frame(width: 50, height: 50)
			   .foregroundColor(.gray)
			   .clipShape(Circle())
		 }
	  }
   }
}


