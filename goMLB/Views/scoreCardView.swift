//   scoreCardView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/10/24 at 1:24 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct ScoreCardView: View {
   @ObservedObject var vm: GameViewModel
   var titleSize: CGFloat
   @Binding var showModal: Bool
   var tooDark: String
   var event: gameEvent
   var scoreSize: Int
   @Binding var numUpdates: Int
   @Binding var refreshGame: Bool
   var timeRemaining: String
   @Binding var selectedEventID: String

   var body: some View {
	  VStack {
		 HStack {
			Text(event.home)
			   .font(.headline)
			   .foregroundColor(Color(hex: event.homeColor))
			Spacer()
			Text(event.visitors)
			   .font(.headline)
			   .foregroundColor(Color(hex: event.visitorColor))
		 }
		 .padding()

		 HStack {
			VStack(alignment: .leading) {
			   Text("Home")
				  .font(.subheadline)
			   HStack {
				  Image(uiImage: loadImage(from: event.homeLogo))
					 .resizable()
					 .frame(width: 50, height: 50)
				  VStack(alignment: .leading) {
					 Text(event.home)
					 Text(event.homeRecord)
				  }
			   }
			}
			Spacer()
			VStack(alignment: .trailing) {
			   Text("Visitors")
				  .font(.subheadline)
			   HStack {
				  VStack(alignment: .trailing) {
					 Text(event.visitors)
					 Text(event.visitorRecord)
				  }
				  Image(uiImage: loadImage(from: event.visitorLogo))
					 .resizable()
					 .frame(width: 50, height: 50)
			   }
			}
		 }
		 .padding()

		 HStack {
			VStack(alignment: .leading) {
			   Text("Inning: \(event.inningTxt)")
			   Text("Balls: \(event.balls ?? 0)")
			   Text("Strikes: \(event.strikes ?? 0)")
			   Text("Outs: \(event.outs ?? 0)")
			}
			Spacer()
			VStack(alignment: .trailing) {
			   Text("Bases")
			   HStack {
				  Text(event.on1 ? "1" : "-")
				  Text(event.on2 ? "2" : "-")
				  Text(event.on3 ? "3" : "-")
			   }
			}
		 }
		 .padding()

		 VStack(alignment: .leading) {
			Text("Last Play: \(event.lastPlay ?? "N/A")")
			Text("At Bat: \(event.atBat ?? "N/A")")
			if !event.atBatPic.isEmpty {
			   Image(uiImage: loadImage(from: event.atBatPic))
				  .resizable()
				  .frame(width: 50, height: 50)
			}
			Text("Batter Stats: \(event.batterStats ?? "N/A")")
			Text("Batter Line: \(event.batterLine ?? "N/A")")
		 }
		 .padding()

		 VStack(alignment: .leading) {
			Text("Pitcher Details")
			VStack(alignment: .leading) {
			   Text("Current Pitcher: \(event.currentPitcherName)")
			   if !event.currentPitcherPic.isEmpty {
				  Image(uiImage: loadImage(from: event.currentPitcherPic))
					 .resizable()
					 .frame(width: 50, height: 50)
			   }
			   Text("ERA: \(event.currentPitcherERA)")
			   Text("Pitches Thrown: \(event.currentPitcherPitchesThrown)")
			   Text("Last Pitch Speed: \(event.currentPitcherLastPitchSpeed ?? "N/A")")
			   Text("Last Pitch Type: \(event.currentPitcherLastPitchType ?? "N/A")")
			}
		 }
		 .padding()
	  }
	  .background(Color(.systemBackground))
	  .cornerRadius(10)
	  .shadow(radius: 5)
	  .padding()
   }

   private func loadImage(from urlString: String) -> UIImage {
	  guard let url = URL(string: urlString),
			let data = try? Data(contentsOf: url),
			let image = UIImage(data: data) else {
		 return UIImage(systemName: "photo") ?? UIImage()
	  }
	  return image
   }
}

struct ScoreCardView_Previews: PreviewProvider {
   static var previews: some View {
	  ScoreCardView(
		 vm: GameViewModel(),
		 titleSize: 20,
		 showModal: .constant(false),
		 tooDark: "#444444",
		 event: gameEvent(
			title: "Sample Game",
			shortTitle: "Sample",
			home: "Yankees",
			visitors: "Red Sox",
			homeRecord: "10-5",
			visitorRecord: "8-7",
			inning: 5,
			homeScore: "5",
			visitScore: "3",
			homeColor: "#003087",
			homeAltColor: "#003087",
			visitorColor: "#BD3039",
			visitorAltColor: "#BD3039",
			on1: true,
			on2: false,
			on3: true,
			lastPlay: "Single to center",
			balls: 2,
			strikes: 1,
			outs: 2,
			homeLogo: "https://example.com/yankees.png",
			visitorLogo: "https://example.com/redsox.png",
			inningTxt: "Bottom 5",
			thisSubStrike: 0,
			thisCalledStrike2: false,
			startDate: "2024-06-01",
			startTime: "13:00",
			atBat: "Aaron Judge",
			atBatPic: "https://example.com/aaronjudge.png",
			atBatSummary: "2 for 3",
			batterStats: ".315",
			batterLine: "2 for 3",
			visitorRuns: "3",
			visitorHits: "5",
			visitorErrors: "1",
			homeRuns: "5",
			homeHits: "7",
			homeErrors: "0",
			currentPitcherName: "Gerrit Cole",
			currentPitcherPic: "https://example.com/gerritcole.png",
			currentPitcherERA: "2.50",
			currentPitcherPitchesThrown: 75,
			currentPitcherLastPitchSpeed: "97 MPH",
			currentPitcherLastPitchType: "Fastball",
			currentPitcherID: "123456",
			currentPitcherThrows: "Right",
			currentPitcherWins: 5,
			currentPitcherLosses: 2,
			currentPitcherStrikeOuts: 55,
			homePitcherName: "Nestor Cortes",
			homePitcherPic: "https://example.com/nestorcortes.png",
			homePitcherERA: "3.20",
			homePitcherID: "654321",
			homePitcherThrows: "Left",
			homePitcherWins: 3,
			homePitcherLosses: 1,
			homePitcherStrikeOuts: 40,
			visitorPitcherName: "Chris Sale",
			visitorPitcherPic: "https://example.com/chrissale.png",
			visitorPitcherERA: "3.75",
			visitorPitcherID: "789012",
			visitorPitcherThrows: "Left",
			visitorPitcherWins: 4,
			visitorPitcherLosses: 3,
			visitorPitcherStrikeOuts: 50,
			atBatID: "111222"
		 ),
		 scoreSize: 15,
		 numUpdates: .constant(10),
		 refreshGame: .constant(true),
		 timeRemaining: "2:15",
		 selectedEventID: .constant("")
	  )
   }
}
