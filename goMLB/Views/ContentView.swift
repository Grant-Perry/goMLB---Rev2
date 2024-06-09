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
   @State var selectedTeam = "New York Yankees"
   @State private var showPicker = false
   @State private var refreshGame = true
   @State var thisTimeRemaining = 15
   @State var timerValue = 15
   @State var maxUpdates = 20
   @State var tooDark = "#bababa"
   @State private var selectedEventID: String?
   @State var showLiveAction = false
   @State var numUpdates = 0
   @State private var showAlert = false
   @State private var isBackgroundDimmed = false
   @State var timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
   @State var fakeTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

   // Constants for View Dimensions and Styles
   private let scoreSize = 55.0
//   private let teamSize = 16.0
   let teamSize: CGFloat
   let teamScoreSize: CGFloat
   private let titleSize = 35.0
   private let logoWidth = 90.0
//   private let teamScoreSize = 25.0
   private let cardColor = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))

   let dateFormatter = DateFormatter()

   var body: some View {
	  VStack(spacing: -15) {
		 List {
			if let event = gameViewModel.filteredEvents.first {
			   let atBat = event.atBat
			   let atBatPic = event.atBatPic
			   let batterStats = event.batterStats
			   let batterLine = event.batterLine
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
							 numUpdates: $numUpdates,
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
								  atBat: atBat,
								  atBatPic: atBatPic,
								  showPic: true,
								  batterStats: batterStats,
								  batterLine: batterLine)
					 }
				  }
			   } else { // not liveAction so show next game
				  Text("Next Game: \(event.startTime)")
					 .font(.subheadline)
					 .frame(maxWidth: .infinity, alignment: .trailing)
			   }
			}
		 }
		 .frame(width: UIScreen.main.bounds.width, height: 565)
		 .padding(.top, -15)
		 Spacer()

		 ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
			   ForEach(gameViewModel.allEvents) { event in
				  Button(action: {
					 selectedEventID = event.id.uuidString
					 gameViewModel.updateTeamPlaying(with: event.visitors)
				  }) {
					 HorizontalCardView(gameViewModel: gameViewModel,
										event: event,
										teamSize: gameViewModel.teamSize,
										teamScoreSize: gameViewModel.teamScoreSize)
				  }
				  .buttonStyle(.plain)
			   }
			}
			.padding()
		 }
		 .frame(maxWidth: .infinity, alignment: .leading)
		 .background(cardColor)
		 .ignoresSafeArea(edges: .bottom)
		 .opacity(0.9)

	  }
	  .onAppear {
		 gameViewModel.loadAllGames(showLiveAction: showLiveAction) {
			if selectedEventID == nil {
			   selectedEventID = gameViewModel.allEvents.first?.id.uuidString
			}
		 }
	  }

	  .onReceive(timer) { _ in
		 if self.refreshGame {
			let previousEventID = self.selectedEventID
			numUpdates += 1
			if numUpdates >= maxUpdates {
			   refreshGame = false
			   showAlert = true
			   isBackgroundDimmed = true
			   timer.upstream.connect().cancel()
			} else {
			   gameViewModel.loadAllGames(showLiveAction: showLiveAction) {
				  DispatchQueue.main.async {
					 self.selectedEventID = previousEventID
				  }
			   }
			   self.thisTimeRemaining = timerValue
			}
		 }
	  }
	  .onReceive(fakeTimer) { _ in
		 if self.thisTimeRemaining > 0 {
			self.thisTimeRemaining -= 1
		 } else {
			self.thisTimeRemaining = 15
		 }
	  }
	  VStack(alignment: .center, spacing: 0) {
		 Text("Version: \(getAppVersion())")
			.font(.system(size: 10))
	  }
	  Button("Refresh") {
		 // also reset and restart the game updates
		 numUpdates = 0
		 thisTimeRemaining = timerValue
		 refreshGame = true
		 gameViewModel.loadAllGames(showLiveAction: showLiveAction)
	  }
	  .font(.footnote)
	  .padding(4)
	  .background(Color.blue)
	  .foregroundColor(.white)
	  .clipShape(Capsule())
	  .preferredColorScheme(.dark)

	  .alert(isPresented: $showAlert) {
		 Alert(
			title: Text("Update Limit Reached"),
			message: Text("Would you like to continue receiving updates?"),
			primaryButton: .default(Text("Continue")) {
			   refreshGame = true
			   numUpdates = 0
			   isBackgroundDimmed = false
			   timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
			},
			secondaryButton: .cancel(Text("Stop")) {
			   isBackgroundDimmed = false
			   refreshGame = false
			}
		 )
	  }
	  .overlay(
		 Group {
			if isBackgroundDimmed {
			   Color.black.opacity(0.5)
				  .edgesIgnoringSafeArea(.all)
			}
		 }
	  )
   }

//   func pickTeam(selectedEventID: Binding<String?>) -> some View {
//	  Picker("Select a matchup:", selection: selectedEventID) {
//		 ForEach(Array(gameViewModel.allEvents.indices.enumerated()), id: \.offset) { index, _ in
//			let event = $gameViewModel.allEvents[index] // Get a binding to the individual event
//			let awayTeam = event.visitors // Removed .wrappedValue
//			let homeTeam = event.home // Removed .wrappedValue
//			llet awayScore = Int(event.wrappedValue.visitScore) ?? 0
//			let homeScore = Int(event.wrappedValue.homeScore) ?? 0
//
//			let startTime = event.startTime
//			let inningTxt = event.inningTxt
//
//
//			let isFinal = inningTxt.contains("Final")
//			let isSuspended = inningTxt.contains("Suspended")
//			let scoreString = (isFinal != 0)
//			? "\(awayScore) | \(homeScore) (Final)"
//			: ((isSuspended != 0)
//			   ? "\(awayScore) | \(homeScore) (Suspended)"
//			   : "\(awayScore) - \(homeScore)")
//
//			let scoreText = awayScore != 0 || homeScore != 0 ? "\(scoreString)" : "\(startTime)"
//			let matchupText = "\(awayTeam) vs. \(homeTeam)\n\(scoreText)"
//
//			VStack(alignment: .leading) {
//			   Text(matchupText)
//				  .font(.headline)
//				  .lineLimit(2)
//				  .fixedSize(horizontal: false, vertical: true)
//			   if awayScore != 0 || homeScore != 0 {
//				  Text(scoreText)
//					 .font(.subheadline)
//					 .foregroundColor(awayScore > homeScore ? .green : .white)
//			   } else {
//				  Text(startTime)
//					 .font(.subheadline)
//			   }
//			}
//			.tag(event.id.uuidString as String?)
//		 }
//	  }
//	  .pickerStyle(MenuPickerStyle())
//	  .padding()
//	  .background(Color.gray.opacity(0.2))
//	  .cornerRadius(10)
//	  .padding(.horizontal)
//	  .onChange(of: selectedEventID.wrappedValue) {
//		 if let newValue = selectedEventID.wrappedValue,
//			let selectedEvent = gameViewModel.allEvents.first(where: { $0.id.uuidString == newValue }) {
//			gameViewModel.updateTeamPlaying(with: selectedEvent.visitors)
//			gameViewModel.teamPlaying = selectedEvent.visitors
//		 }
//	  }
//   }
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
   ContentView(teamSize: AppConstants.teamSize, teamScoreSize: AppConstants.teamScoreSize)
}
