//   HorizontalMatchupView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/25/24 at 6:05 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//


import SwiftUI

struct MatchupView: View {
   @ObservedObject var gameViewModel: GameViewModel
   var event: gameEvent

   var body: some View {
	  VStack {
		 HStack {
			Text(event.visitors)
			   .font(.system(size: 16, weight: .bold))
			   .foregroundColor(.white)
			Spacer()
			Text(event.home)
			   .font(.system(size: 16, weight: .bold))
			   .foregroundColor(.white)
		 }
		 .padding()

		 HStack {
			Text("Runs: \(event.visitorRuns)")
			Text("Hits: \(event.visitorHits)")
			Text("Errors: \(event.visitorErrors)")
		 }
		 .padding(.horizontal)
		 .foregroundColor(.white)
		 .font(.system(size: 12))

		 HStack {
			Text("Runs: \(event.homeRuns)")
			Text("Hits: \(event.homeHits)")
			Text("Errors: \(event.homeErrors)")
		 }
		 .padding(.horizontal)
		 .foregroundColor(.white)
		 .font(.system(size: 12))

		 if !event.atBat.isEmpty {
			VStack {
			   Text("At Bat: \(event.atBat)")
				  .font(.headline)
			   Text("Stats: \(event.batterStats)")
				  .font(.subheadline)
			   Text("Line: \(event.batterLine)")
				  .font(.subheadline)
			}
			.padding()
			.foregroundColor(.white)
		 }
	  }
	  .background(Color.black.opacity(0.7))
	  .cornerRadius(10)
	  .padding()
   }
}
