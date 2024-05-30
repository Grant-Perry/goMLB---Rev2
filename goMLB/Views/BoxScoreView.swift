//   BoxScoreView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/29/24 at 6:01 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct BoxScoreView: View {
   @ObservedObject var gameViewModel: GameViewModel

   var body: some View {
	  VStack {
		 Text("Line Score")
			.font(.title)
		 HStack {
			VStack {
			   Text("Inning")
			   ForEach(0..<10, id: \.self) { inning in
//			   ForEach(0..<$gameViewModel.visitorLineScores.count, id: \.self) { inning in
				  Text("\(inning + 1)")
			   }
			}
			VStack {
			   Text("Visitor")
			   ForEach(0..<10, id: \.self) {  score in
				  Text("\(score + 1)")
			   }
			}
			VStack {
			   Text("Home")
			   ForEach(gameViewModel.homeLineScores, id: \.self) { score in
				  Text(score)
			   }
			}
		 }
		 HStack {
			VStack {
			   Text("R")
			   Text(gameViewModel.visitorRuns)
			   Text(gameViewModel.theHomeRuns)
			}
			VStack {
			   Text("H")
			   Text(gameViewModel.visitorHits)
			   Text(gameViewModel.homeHits)
			}
			VStack {
			   Text("E")
			   Text(gameViewModel.visitorErrors)
			   Text(gameViewModel.homeErrors)
			}
		 }
		 if let startingPitcher = gameViewModel.startingPitcher {
			VStack {
			   Text("Starting Pitcher")
			   Text(startingPitcher)
			   Text("ERA:2.03")
			   if let headshot = startingPitcher.headshot {
				  AsyncImage(url: URL(string: headshot))
			   }
			}
		 }
		 if let currentPitcher = gameViewModel.currentPitcher {
			VStack {
			   Text("Current Pitcher")
			   Text(currentPitcher.fullName)
			   Text("ERA: \(currentPitcher.statistics.first(where: { $0.name == "ERA" })?.displayValue ?? "N/A")")
			   if let headshot = currentPitcher.headshot {
				  AsyncImage(url: URL(string: headshot))
			   }
			}
		 }
	  }
   }
}

struct BoxScoreView_Previews: PreviewProvider {
   static var previews: some View {
	  BoxScoreView(gameViewModel: GameViewModel.dummyData())
   }
}

//
//#Preview {
//    BoxScoreView()
//}
