//   HorizontalCardView.swift
//   goMLB
//
//   Created by: Grant Perry on 6/8/24 at 11:03 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct HorizontalCardView: View {
   var game: gameEvent

   var body: some View {
	  VStack {
		 HStack {
			VStack(alignment: .leading) {
			   HStack {
				  Text(game.home)
					 .font(.largeTitle)
					 .bold()
					 .foregroundColor(.white)
				  Spacer()
				  Text(game.homeScore)
					 .font(.title)
					 .foregroundColor(.white)
			   }
			   HStack {
				  Text(game.visitors)
					 .font(.largeTitle)
					 .bold()
					 .foregroundColor(.white)
				  Spacer()
				  Text(game.visitScore)
					 .font(.title)
					 .foregroundColor(.white)
			   }
			}
			.padding()
		 }
		 .background(Color.blue)
		 .cornerRadius(10)
		 .padding([.leading, .trailing])

		 HStack {
			VStack(alignment: .leading) {
			   HStack {
				  Image(uiImage: loadImage(from: game.homeLogo))
					 .resizable()
					 .frame(width: 50, height: 50)
				  VStack(alignment: .leading) {
					 Text(game.home)
					 Text(game.homeRecord)
				  }
			   }
			}
			Spacer()
			VStack(alignment: .trailing) {
			   HStack {
				  VStack(alignment: .trailing) {
					 Text(game.visitors)
					 Text(game.visitorRecord)
				  }
				  Image(uiImage: loadImage(from: game.visitorLogo))
					 .resizable()
					 .frame(width: 50, height: 50)
			   }
			}
		 }
		 .padding([.leading, .trailing])

		 VStack(alignment: .leading) {
			Text("Inning: \(game.inningTxt)")
			Text("Last Play: \(game.lastPlay ?? "N/A")")
			Text("At Bat: \(game.atBat ?? "N/A")")
			if !game.atBatPic.isEmpty {
			   Image(uiImage: loadImage(from: game.atBatPic))
				  .resizable()
				  .frame(width: 50, height: 50)
			}
		 }
		 .padding()

		 VStack(alignment: .leading) {
			Text("Pitcher Details")
			VStack(alignment: .leading) {
			   Text("Current Pitcher: \(game.currentPitcherName)")
			   if !game.currentPitcherPic.isEmpty {
				  Image(uiImage: loadImage(from: game.currentPitcherPic))
					 .resizable()
					 .frame(width: 50, height: 50)
			   }
			   Text("ERA: \(game.currentPitcherERA)")
			   Text("Pitches Thrown: \(game.currentPitcherPitchesThrown)")
			   Text("Last Pitch Speed: \(game.currentPitcherLastPitchSpeed ?? "N/A")")
			   Text("Last Pitch Type: \(game.currentPitcherLastPitchType ?? "N/A")")
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

struct HorizontalCardView_Previews: PreviewProvider {
   static var previews: some View {
	  HorizontalCardView(game: gameEvent(
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
	  ))
   }
}


