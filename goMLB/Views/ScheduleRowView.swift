//   ScheduleRowView.swift
//   goMLB
//
//   Created by: Grant Perry on 6/22/24 at 2:09 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct ScheduleRowView: View {
   let game: [String: String]
   let teamColor: String
   let teams: [[String: String]]

   var body: some View {
	  HStack {
		 VStack(alignment: .leading) {
			Text(game["displayDate"] ?? "")
			   .font(.subheadline)
			   .foregroundColor(.gray)
			Text(game["time"] ?? "")
			   .font(.headline)
			   .foregroundColor(Color(hex: teamColor))
		 }
		 Spacer()
		 if let matchup = game["matchup"] {
			let teamsArray = matchup.components(separatedBy: " vs ")
			if teamsArray.count == 2,
			   let homeTeam = teams.first(where: { $0["teamName"] == teamsArray[0] }),
			   let awayTeam = teams.first(where: { $0["teamName"] == teamsArray[1] }) {
			   VStack {
				  AsyncImage(url: URL(string: homeTeam["teamLogo"] ?? "")) { image in
					 image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 30, height: 30)
						.clipShape(Circle())
				  } placeholder: {
					 ProgressView()
				  }
				  Text(homeTeam["teamRecord"] ?? "")
					 .font(.caption)
					 .foregroundColor(.gray)
			   }
			   Text("@").font(.headline).foregroundColor(.gray)
			   VStack {
				  AsyncImage(url: URL(string: awayTeam["teamLogo"] ?? "")) { image in
					 image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 30, height: 30)
						.clipShape(Circle())
				  } placeholder: {
					 ProgressView()
				  }
				  Text(awayTeam["teamRecord"] ?? "")
					 .font(.caption)
					 .foregroundColor(.gray)
			   }
			}
		 }
		 Spacer()
	  }
	  .padding()
	  .background(Color.gray.opacity(0.1)) // Brighter background for row
	  .cornerRadius(10)
   }
}
