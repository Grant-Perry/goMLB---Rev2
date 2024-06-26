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
   private var scoreSize = 55.0
   private var titleSize = 35.0
   private var logoWidth = 90.0
   private var teamSize = 16.0
   private var teamScoreSize = 25.0
   @State var version = "99.8"
   @State var tooDark = "#bababa"
   @State private var selectedEventID: String? = nil
   @State var showLiveAction = false
   @State var initialLoad = true // initial load for
   var cardColor = Color(#colorLiteral(red: 0.1487929029, green: 0.1488425059, blue: 0.1603987949, alpha: 1))
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
		 .frame(width: UIScreen.main.bounds.width, height: 590)
		 .padding(.top, -15)
		 Spacer()

		 // MARK: MatchupView - horizontal game matchup's card view
//Spacer()
		 MatchupView(gameViewModel: gameViewModel,
					 selectedEventID: $selectedEventID,
					 teamSize: teamSize,
					 teamScoreSize: teamScoreSize,
					 cardColor: cardColor)
		 .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottom)
	  }
	  .onAppear {
		 gameViewModel.loadAllGames(showLiveAction: showLiveAction) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			   if initialLoad {
				  if let yankeesEventID = gameViewModel.allEvents.first(where: { $0.home == "New York Yankees" || $0.visitors == "New York Yankees" })?.ID.uuidString {
//					 print("Yankees game found with ID: \(yankeesEventID)")
					 selectedEventID = yankeesEventID
					 initialLoad = false
				  } else {
//					 print("Yankees game not found")
				  }
			   }
			}
		 }
	  }
	  .onReceive(timer) { _ in
		 print("Updating now...")
		 if self.refreshGame {
			gameViewModel.loadAllGames(showLiveAction: showLiveAction)
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
			   .onChange(of: showLiveAction) {
				  gameViewModel.loadAllGames(showLiveAction: showLiveAction)
			   }
		 }
		 .padding()
		 //		 		 pickTeam(selectedEventID: $selectedEventID)
		 Text("© 2024 Delicious Studios, LLC. - Ver: \(getAppVersion())")
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
}

// MARK: Helpers

extension ContentView {

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

	  .onChange(of: selectedEventID.wrappedValue) {
		 if let newValue = selectedEventID.wrappedValue,
			let selectedEvent = gameViewModel.allEvents.first(where: { $0.ID.uuidString == newValue }) {
			gameViewModel.updateTeamPlaying(with: selectedEvent.visitors)
			gameViewModel.teamPlaying = selectedEvent.visitors
		 }
	  }
   }

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
