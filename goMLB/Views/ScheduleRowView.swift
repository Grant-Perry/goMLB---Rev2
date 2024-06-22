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
			   AsyncImage(url: URL(string: homeTeam["teamLogo"] ?? "")) { image in
				  image
					 .resizable()
					 .aspectRatio(contentMode: .fit)
					 .frame(width: 30, height: 30)
					 .clipShape(Circle())
			   } placeholder: {
				  ProgressView()
			   }
			   Text("@").font(.headline).foregroundColor(.gray)
			   AsyncImage(url: URL(string: awayTeam["teamLogo"] ?? "")) { image in
				  image
					 .resizable()
					 .aspectRatio(contentMode: .fit)
					 .frame(width: 30, height: 30)
					 .clipShape(Circle())
			   } placeholder: {
				  ProgressView()
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
