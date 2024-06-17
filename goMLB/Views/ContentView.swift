//   ContentView.swift
//   goMLB
//
//   Created by: Grant Perry on 4/21/24 at 4:37 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct ContentView: View {
   @StateObject private var gameViewModel = GameViewModel()
   @State private var showModal = false
   @State private var tooDark = "false"
   @State private var selectedEventID: String = ""
   @State private var numUpdates = 0
   @State private var refreshGame = false
   @State private var thisTimeRemaining = "0"

   var teamSize: CGFloat
   var teamScoreSize: CGFloat

   var body: some View {
	  NavigationView {
		 VStack {
			Text("MLB Games")
			   .font(.largeTitle)
			   .padding()

			List(gameViewModel.filteredEvents) { event in
			   ScoreCardView(
				  vm: gameViewModel,
				  titleSize: 20,
				  showModal: $showModal,
				  tooDark: tooDark,
				  event: event,
				  scoreSize: 15,
				  numUpdates: $numUpdates,
				  refreshGame: $refreshGame,
				  timeRemaining: thisTimeRemaining,
				  selectedEventID: $selectedEventID
			   )
			   .onTapGesture {
				  selectedEventID = event.id.uuidString
				  showModal.toggle()
			   }
			}
			.onAppear {
			   gameViewModel.loadAllGames(showLiveAction: true)
			}
			.refreshable {
			   gameViewModel.loadAllGames(showLiveAction: true)
			}
			.navigationBarTitle("MLB Games", displayMode: .inline)
			.navigationBarItems(trailing: Button(action: {
			   refreshGame.toggle()
			}) {
			   Image(systemName: "arrow.clockwise")
			})
		 }
	  }
	  
	  .sheet(isPresented: $showModal) {
		 if let selectedEvent = gameViewModel.filteredEvents.first(where: { $0.id.uuidString == selectedEventID }) {
			VStack {
			   Text(selectedEvent.title)
				  .font(.title)
				  .padding()

			   Text("Home: \(selectedEvent.home) - \(selectedEvent.homeScore)")
			   Text("Visitors: \(selectedEvent.visitors) - \(selectedEvent.visitScore)")

			   BasesView(onFirst: selectedEvent.on1, onSecond: selectedEvent.on2, onThird: selectedEvent.on3)
				  .padding()

			   outsView(outs: selectedEvent.outs ?? 0)
				  .padding()

			   TeamIconView(teamName: selectedEvent.home, teamLogo: selectedEvent.homeLogo)
				  .padding()

			   TeamIconView(teamName: selectedEvent.visitors, teamLogo: selectedEvent.visitorLogo)
				  .padding()

			   PitcherDetailsView(
				  pitcherName: selectedEvent.currentPitcherName,
				  pitcherPic: selectedEvent.currentPitcherPic,
				  pitcherERA: selectedEvent.currentPitcherERA,
				  pitcherWins: selectedEvent.currentPitcherWins,
				  pitcherLosses: selectedEvent.currentPitcherLosses,
				  pitcherStrikeOuts: selectedEvent.currentPitcherStrikeOuts,
				  pitcherThrows: selectedEvent.currentPitcherThrows
			   )
			   .padding()
			}
		 }
	  }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
	  ContentView(teamSize: 16, teamScoreSize: 25)
   }
}
