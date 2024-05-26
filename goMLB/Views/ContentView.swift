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
   @ObservedObject var gameViewModel = GameViewModel()
   @Environment(\.colorScheme) var colorScheme
   @State private var showPicker = false
   @State private var refreshGame = true // refetch JSON
   @State var thisTimeRemaining = 15
   @State var selectedTeam = "New York Yankees"
   @State var timerValue = 15
   @State var timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
   @State var fakeTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   @State var scoreColor = Color(.blue)
   @State var winners = Color(.green)
   @State var scoreSize = 55.0
   @State var titleSize = 35.0
   @State var logoWidth = 90.0
   @State var version = "99.8"
   @State var tooDark = "#bababa"
   @State private var selectedEventID: String?
   @State var showLiveAction = false

   private var teamSize = 16.0
   private var teamScoreSize = 20.0

   let dateFormatter = DateFormatter()

   var body: some View {
	  VStack(spacing: -15) {
		 List(gameViewModel.filteredEvents.prefix(1), id: \.ID) { event in
			let vm = gameViewModel.filteredEvents.first
			let atBat = vm?.atBat
			let atBatPic = vm?.atBatPic
			var liveAction: Bool {
			   if event.inningTxt.contains("Final") || event.inningTxt.contains("Scheduled") {
				  return false
			   } else {
				  return true
			   }
			}

			// MARK: Title / Header Tile
			scoreCardView(vm: gameViewModel,
						  titleSize: titleSize,
						  tooDark: tooDark,
						  event: event,
						  scoreSize: Int(scoreSize),
						  refreshGame: $refreshGame,
						  timeRemaining: $thisTimeRemaining)

			if liveAction {
			   VStack {
				  // MARK: Last Play & Bases card
				  HStack {
					 if let lastPlay = event.lastPlay {
						Text(lastPlay)
						   .font(.footnote)
						   .lineLimit(1)
						   .minimumScaleFactor(0.5)
						   .scaledToFit()
					 }
				  }

				  // MARK: Bases View
				  HStack {
					 BasesView(onFirst: event.on1,
							   onSecond: event.on2,
							   onThird: event.on3,
							   strikes: event.strikes ?? 0,
							   balls: event.balls ?? 0,
							   outs: event.outs ?? 0,
							   inning: event.inning,
							   inningTxt: event.inningTxt,
							   thisSubStrike: event.thisSubStrike,
							   atBat: atBat ?? "N/A",
							   atBatPic: atBatPic ?? "N/A URL",
							   showPic: true)
				  }
			   }
			} else { // not liveAction so show next game
			   Text("Next Game: \(event.startTime)")
				  .font(.subheadline)
				  .frame(maxWidth: .infinity, alignment: .trailing)
			}
		 }
		 .frame(width: UIScreen.main.bounds.width, height: 565)
		 .padding(.top, -35)

		 // MARK: HorizontalMatchupView list

		 //		 MatchupView(gameViewModel: gameViewModel, selectedEventID: $selectedEventID)
		 ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
			   ForEach(gameViewModel.allEvents, id: \.ID) { event in

				  let vm = gameViewModel.filteredEvents.first
				  let atBat = vm?.atBat
				  let atBatPic = vm?.atBatPic

				  var liveAction: Bool {
					 if event.inningTxt.contains("Final") || event.inningTxt.contains("Scheduled") {
						return false
					 } else {
						return true
					 }
				  }

				  Button(action: {
					 selectedEventID = event.ID.uuidString
					 gameViewModel.updateTeamPlaying(with: event.visitors)
					 gameViewModel.teamPlaying = event.visitors
				  }) {
					 VStack {
						HStack(spacing: 3) {
						   HStack {
							  Text(event.visitors)
								 .font(.system(size: teamSize, weight: .bold))
								 .foregroundColor(.white)
						   }
						   HStack {
							  Text("vs.")
								 .font(.footnote)
						   }
						   HStack {
							  Text(event.home)
								 .font(.system(size: teamSize, weight: .bold))
								 .foregroundColor(.white)
							  //							  Spacer()
						   }
						}
						HStack {

						   HStack {
							  Spacer()
							  Text(event.visitScore)
								 .font(.system(size: teamScoreSize))
								 .foregroundColor(.white)

							  Spacer()
						   }
						   if liveAction {
							  HStack {
								 BasesView(onFirst: event.on1,
										   onSecond: event.on2,
										   onThird: event.on3,
										   strikes: event.strikes ?? 0,
										   balls: event.balls ?? 0,
										   outs: event.outs ?? 0,
										   inning: event.inning,
										   inningTxt: event.inningTxt,
										   thisSubStrike: event.thisSubStrike,
										   atBat: atBat ?? "N/A",
										   atBatPic: atBatPic ?? "N/A URL",
										   showPic: false)
								 .scaleEffect(0.55)


							  }
							  .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height:20)
							  .padding(.top, 6)
						   }
						   HStack {
							  Spacer()
							  Text(event.homeScore)
								 .font(.system(size: teamScoreSize))
								 .foregroundColor(.white)
							  Spacer()
						   }
						}
					 }
					 .frame(width: 165, height: 120)
					 //					 .background(liveAction ? Color.blue.gradient : Color.green.gradient)
					 .background(
						event.inningTxt.contains("Final") ? Color.indigo.gradient :
						   event.inningTxt.contains("Scheduled") ? Color.yellow.gradient :
						   Color.blue.gradient
					 )
					 .foregroundColor(.white)
					 //						.foregroundColor(
					 //						   event.inningTxt.contains("Final") ? Color.white.gradient :
					 //							  event.inningTxt.contains("Scheduled") ? Color.white.gradient :
					 //							  Color.white.gradient
					 //						)
					 .cornerRadius(10)
					 .opacity(0.9)
				  }
				  .buttonStyle(PlainButtonStyle())
				  //				  }
			   }
			}
			.padding(.horizontal)
		 }
		 .padding()

		 .frame(height: 100)
		 .padding(.top, -15)
	  }

	  .onAppear {
		 gameViewModel.loadAllGames(showLiveAction: showLiveAction)
		 if selectedEventID == nil, let firstEventID = gameViewModel.allEvents.first?.ID.uuidString {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			   selectedEventID = firstEventID
			}
		 }
	  }

	  .onReceive(timer) { _ in
		 print("Updating now...")
		 if self.refreshGame {
			let previousEventID = self.selectedEventID
			gameViewModel.loadAllGames(showLiveAction: showLiveAction) {
			   DispatchQueue.main.async {
				  self.selectedEventID = previousEventID
			   }
			}
		 }
		 self.thisTimeRemaining = timerValue
		 print("Reloading now...")
	  }

	  .onReceive(fakeTimer) { _ in
		 if self.thisTimeRemaining > 0 {
			self.thisTimeRemaining -= 1
		 } else {
			self.thisTimeRemaining = 15
		 }
	  }
	  VStack(alignment: .center, spacing: 0) {
		 HStack(spacing: 0) {
			Text("Live Action Only:")
			   .font(.caption)
			Toggle("", isOn: $showLiveAction)
			   .labelsHidden()
			   .scaleEffect(0.6)
			// THIS WORKS - but it will not alter the game cards when toggled so fix
			//			   .onChange(of: showLiveAction) { newValue in
			//				  gameViewModel.loadAllGames(showLiveAction: newValue)
			//			   }
		 }

		 .padding()
//		 		 pickTeam(selectedEventID: $selectedEventID)
		 		 Text("Version: \(getAppVersion())")
		 			.font(.system(size: 10))
	  }
	  Button("Refresh") {
		 gameViewModel.loadAllGames(showLiveAction: showLiveAction)
	  }
	  .font(.footnote)
	  .padding(4)
	  .background(Color.blue)
	  .foregroundColor(.white)
	  .clipShape(Capsule())
	  .preferredColorScheme(.dark)
   }

   func pickTeam(selectedEventID: Binding<String?>) -> some View {
	  Picker("Select a matchup:", selection: selectedEventID) {
		 ForEach(gameViewModel.allEvents, id: \.ID) { event in
			let awayTeam = event.visitors
			let homeTeam = event.home
			let awayScore = Int(event.visitScore) ?? 0
			let homeScore = Int(event.homeScore) ?? 0
			let startTime = event.startTime
			let inningTxt = event.inningTxt

			let isFinal = inningTxt.contains("Final")
			let isSuspended = inningTxt.contains("Suspended")
			let scoreString = isFinal
			? "\(awayScore) | \(homeScore) (Final)"
			: (isSuspended
			   ? "\(awayScore) | \(homeScore) (Suspended)"
			   : "\(awayScore) - \(homeScore)")

			let scoreText = awayScore != 0 || homeScore != 0 ? "\(scoreString)" : "\(startTime)"
			let matchupText = "\(awayTeam) vs. \(homeTeam)\n\(scoreText)"

			VStack(alignment: .leading) {
			   Text(matchupText)
				  .font(.headline)
				  .lineLimit(2)
				  .fixedSize(horizontal: false, vertical: true)
			   if awayScore != 0 || homeScore != 0 {
				  Text(scoreText)
					 .font(.subheadline)
					 .foregroundColor(awayScore > homeScore ? .green : .white)
			   } else {
				  Text(startTime)
					 .font(.subheadline)
			   }
			}
			.tag(event.ID.uuidString as String?)
		 }
	  }
	  .pickerStyle(MenuPickerStyle())
	  .padding()
	  .background(Color.gray.opacity(0.2))
	  .cornerRadius(10)
	  .padding(.horizontal)

	  .onChange(of: selectedEventID.wrappedValue) { newValue in
		 if let newValue = newValue,
			let selectedEvent = gameViewModel.allEvents.first(where: { $0.ID.uuidString == newValue }) {
			gameViewModel.updateTeamPlaying(with: selectedEvent.visitors)
			gameViewModel.teamPlaying = selectedEvent.visitors
		 }
	  }
   }
}

// MARK: Helpers

extension ContentView {
   func isHexGreaterThan(_ hex1: String, comparedTo hex2: String) -> Bool {
	  guard let int1 = hexToInt(hex1), let int2 = hexToInt(hex2) else {
		 return false
	  }
	  return int1 > int2
   }

   func hexToInt(_ hex: String) -> Int? {
	  var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

	  if hexSanitized.hasPrefix("#") {
		 hexSanitized.remove(at: hexSanitized.startIndex)
	  }

	  var intValue: UInt64 = 0
	  Scanner(string: hexSanitized).scanHexInt64(&intValue)
	  return Int(intValue)
   }

   func getAppVersion() -> String {
	  if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
		 return version
	  } else {
		 return "Unknown version"
	  }
   }
}

// Preview

#Preview {
   ContentView()
}
