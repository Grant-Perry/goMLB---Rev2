//   teamIconView.swift
//   goMLB
//
//   Created by: Gp. on 4/25/24 at 10:30 AM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
private var gameViewModel: GameViewModel = GameViewModel()

struct TeamIconView: View {
   var team: APIResponse.Event.Competition.Competitor.Team

   var body: some View {
	  let teamColor = team.color ?? "#000000" // Default to black if color is not provided
	  let teamIcon = getPreferredLogo(for: team)

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

   // Function to get the preferred logo
   func getPreferredLogo(for team: APIResponse.Event.Competition.Competitor.Team) -> String {
	  // Prefer the second logo URL if it exists
	  if let logos = team.logos, logos.count > 1 {
		 return logos[1].href
	  }
	  // Fallback to the first logo if the second doesn't exist
	  return team.logos?.first?.href ?? team.logo ?? ""
   }
}





