//   ContentView.swift
//   goMLB
//
//   Created by: Grant Perry on 4/21/24 at 4:37 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

// THIS
import SwiftUI

struct ContentView: View {
   @ObservedObject var gameViewModel = GameViewModel()
   @Environment(\.colorScheme) var colorScheme
   @State var selectedTeam = "New York Yankees"
   @State private var showPicker = false
   @State private var refreshGame = true
   @State var thisTimeRemaining = 15
   @State var timerValue = 15
   @State var showModal = false
   @State var tooDark = "#333333"
   @State private var selectedEventID: String?
   @State var showLiveAction = false
   @State var numUpdates = 0
   @State private var showAlert = false
   @State private var isBackgroundDimmed = false
   @State var timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
   @State var fakeTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

   // Constants for View Dimensions and Styles
   private let scoreSize = 55.0
   let teamSize: CGFloat
   let teamScoreSize: CGFloat
   private let titleSize = 35.0
   private let logoWidth = 90.0
   private let cardColor = Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1))

   let dateFormatter: DateFormatter = {
	  let formatter = DateFormatter()
	  formatter.dateFormat = "yyyy-MM-dd" // Match the format of event.startDate
	  return formatter
   }()

   var body: some View {
	  VStack(spacing: -15) {
		 List {
			if let event = gameViewModel.filteredEvents.first {
			   let atBat = event.atBat
			   let atBatPic = event.atBatPic
			   let batterStats = event.batterStats
			   let batterLine = event.batterLine

			   ScoreCardView(
				  vm: gameViewModel,
				  selectedEventID: $selectedEventID,
				  showModal: $showModal,
				  titleSize: titleSize,
				  tooDark: tooDark,
				  event: event,
				  scoreSize: Int(scoreSize),
				  numUpdates: $numUpdates,
				  refreshGame: $refreshGame,
				  timeRemaining: $thisTimeRemaining
			   )

			   if event.isInProgress {
				  VStack {
					 HStack {
						if let lastPlay = event.lastPlay {
						   Text("LP: \(lastPlay)")
							  .font(.system(size: 18))
							  .lineLimit(2)
							  .minimumScaleFactor(0.5)
							  .scaledToFit()
						}
					 }

					 HStack {
						BasesView(
						   onFirst: event.on1,
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
						   batterLine: batterLine
						)
					 }
				  }
			   } else {
				  PitcherDetailsView(event: event)
				  Text(event.nextGameDisplayText)
					 .font(.subheadline)
					 .frame(maxWidth: .infinity, alignment: .trailing)
			   }
			}
		 }
		 .frame(width: UIScreen.main.bounds.width, height: 565)
		 .padding(.top, -15)
		 .listStyle(.plain)
		 .refreshable {
			gameViewModel.loadAllGames(showLiveAction: true)
		 }
		 .navigationBarTitle("MLB Games", displayMode: .inline)
		 .navigationBarItems(trailing: Button(action: {
			refreshGame.toggle()
		 }) {
			Image(systemName: "arrow.clockwise")
		 })

		 ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
			   ForEach(gameViewModel.allEvents, id: \.id) { event in
				  Button(action: {
					 selectedEventID = event.id.uuidString
					 gameViewModel.teamPlaying = event.visitors // Update the team playing to the selected team
					 gameViewModel.loadAllGames(showLiveAction: showLiveAction) {
						DispatchQueue.main.async {
						   selectedEventID = event.id.uuidString
						}
					 }
				  }) {
					 HorizontalCardView(
						gameViewModel: gameViewModel,
						event: event,
						teamSize: teamSize,
						teamScoreSize: teamScoreSize
					 )
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
		 selectedTeam = gameViewModel.favTeam // Set selectedTeam to favTeam
		 gameViewModel.teamPlaying = selectedTeam // Update the team playing to the selected team
		 gameViewModel.loadAllGames(showLiveAction: showLiveAction) {
			DispatchQueue.main.async {
			   gameViewModel.teamPlaying = selectedTeam // Ensure filtering is called again after loading
			   if selectedEventID == nil {
				  selectedEventID = gameViewModel.filteredEvents.first?.id.uuidString
			   }
			}
		 }
	  }

	  .onReceive(timer) { _ in
		 if self.refreshGame {
			let previousEventID = self.selectedEventID
			numUpdates += 1
			if numUpdates >= gameViewModel.maxUpdates {
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
	  Button(action: {
		 // Reset and restart the game updates
		 numUpdates = 0
		 thisTimeRemaining = timerValue
		 refreshGame = true
		 gameViewModel.loadAllGames(showLiveAction: showLiveAction)
	  }) {
		 Image(systemName: "arrow.clockwise")
			.font(.footnote)

	  }

	  .font(.footnote)
	  .padding(4)
	  .background(Color.blue.gradient)
	  .foregroundColor(.white)
	  .clipShape(Capsule())
	  .preferredColorScheme(.dark)
	  .alert(isPresented: $showAlert) {
		 Alert(
			title: Text("Pump the brakes..."),
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
