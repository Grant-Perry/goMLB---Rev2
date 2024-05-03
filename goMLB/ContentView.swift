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

   let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
   let scoreColor = Color(.blue)
   let winners = Color(.green)

   let scoreSize = 55.0
   let titleSize = 25.0
   let logoWidth = 90.0
   let version = "99.8"
   let tooDark = "#333333"

   //	var teams = MLBTeams.teams
   @State var selectedTeam = "New York Yankees"

   var body: some View {
	  VStack(spacing: 0) {
		 List(gameViewModel.filteredEvents, id: \.ID) { event in
			let vm = gameViewModel.filteredEvents.first
			let home = vm?.home
			let homeScore = vm?.homeScore ?? "0"
			let homeColor = vm?.homeColor
			let visitors = vm?.visitors
			let visitScore = vm?.visitScore ?? "0"
			let visitColor = vm?.visitorAltColor
			let homeWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) ? false : true
			let visitWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) ? true : false
			let inningTxt = vm?.inningTxt
			let startTime = vm?.startTime
			let atBat = vm?.atBat
			let atBatPic = vm?.atBatPic
			let atBatSummary = vm?.atBatSummary
			let winColor = Color.green
			let liveAction: Bool = true // event.inningTxt.lowercased().contains("Start") || event.inningTxt.lowercased().contains("Sch")
//			let midInning: Bool = event.inningTxt.lowercased().contains("Top") || event.inningTxt.lowercased().contains("Bottom")


			//	MARK: Title / Header Tile
			VStack {
			   Section {
				  VStack(spacing: 0) {
					 HStack(alignment: .center) {
						VStack(spacing: -4) {  // Remove spacing between VStack elements

						   Text("\(visitors ?? "")")
							  .font(.system(size: titleSize))
//							  .foregroundColor(Color(hex: isHexGreaterThan(visitColor ?? "#000", comparedTo: tooDark) ? visitColor! : tooDark))
							  .foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
							  .multilineTextAlignment(.center)

						   Text("vs.")
							  .font(.footnote)
							  .multilineTextAlignment(.center)
							  .padding(.vertical, 2)

						   Text("\(home ?? "")")
							  .font(.system(size: titleSize))
//							  .foregroundColor(Color(hex: isHexGreaterThan(homeColor ?? "#000", comparedTo: tooDark) ? homeColor! : tooDark))
							  .foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
							  .multilineTextAlignment(.center)

						   if (inningTxt?.contains("Scheduled") ?? false ) {
							  Text("\nStarting: \(startTime ?? "")")
								 .font(.system(size: 14))
								 .foregroundColor(.white)
						   }
						   else {
							  Text("\n\(inningTxt ?? "")")
								 .font(.system(size: 14))
								 .foregroundColor(.white)
						   }

						   // MARK: Outs view

						   if let lowerInningTxt = inningTxt {
							  if lowerInningTxt.contains("Top") || lowerInningTxt.contains("Bot")  {
								 outsView(outs: event.outs ?? 0 )
									.frame(width: UIScreen.main.bounds.width, height: 20)
									.padding(.top, 6)
									.font(.system(size: 11))
							  }
						   }
						}
						.multilineTextAlignment(.center)
						.padding()
						.lineSpacing(0)
					 }
					 .frame(width: UIScreen.main.bounds.width, height: 200)
					 .minimumScaleFactor(0.25)
					 .scaledToFit()
				  }
			   }  // end title section
			   .frame(width: UIScreen.main.bounds.width, height: 130, alignment: .trailing)
//			   .shadow(color: .white, radius: 10, x: 0, y: 0)
			   .cornerRadius(10)
			}

			// MARK: Scores card
			// MARK: First column - visitor's score (Right justified)

			Section {
			   HStack(spacing: 0) {

				  HStack { // Visitor Side
					 VStack(alignment: .leading) {
						VStack {
						   Text("\(visitors ?? "")")
							  .font(.title3)
//							  .foregroundColor(Color(hex: isHexGreaterThan(visitColor ?? "#000", comparedTo: tooDark) ? visitColor! : tooDark))
							  .foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))

						   Text("\(vm?.visitorRecord ?? "")")
							  .font(.caption)
							  .foregroundColor(.gray)
						   Spacer()
						}
						VStack {
						   TeamIconView(teamColor: visitColor ?? "C4CED3", teamIcon: event.visitorLogo)
							  .clipShape(Circle())
//							  .shadow(color: .gray, radius: 10, x: 0, y: 0)
//							  .shadow(color: Color(hex: visitColor ?? "#000000"), radius: 10, x: 0, y: 0)

						}
					 }
// MARK: Visitor Score
					 Text("\(visitScore)")
						.font(.system(size: scoreSize))
						.padding(.trailing)
						.foregroundColor(visitWin && Int(visitScore) ?? 0 > 0 ? winColor : Color(hex: visitColor!))

//						.shadow(color: .white, radius: 10, x: 0, y: 0)
//						.shadow(color: Color(hex: visitColor ?? "#000000"), radius: 10, x: 0, y: 0)


				  } // end Visitor Side


				  HStack { // Home side
					 Text("\(homeScore)")
						.font(.system(size: scoreSize))
						.padding(.leading)
						.foregroundColor(homeWin && Int(homeScore) ?? 0 > 0 ? winColor : Color(hex: homeColor!))
//						.shadow(color: .white, radius: 10, x: 0, y: 0)


				     VStack(alignment: .leading) {
						Text("\(home ?? "")")
						   .font(.title3)
						   .foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))


						Text("\(vm?.homeRecord ?? "")")
						   .font(.caption)
						   .foregroundColor(.gray)

						VStack(alignment: .leading) {
						   TeamIconView(teamColor: homeColor ?? "C4CED3", teamIcon: event.homeLogo)
							  .frame(width: logoWidth)
							  .clipShape(Circle())
//							  .shadow(color: .gray, radius: 10, x: 0, y: 0)
//							  .shadow(color: Color(hex: homeColor ?? "#000000"), radius: 10, x: 0, y: 0)

						}
					 }
//					 .frame(width: UIScreen.main.bounds.width * 0.35)
				  } // end Home side



			   }
			   .padding()
			   .frame(width: UIScreen.main.bounds.width, height: 110) // for the score card
			}

			if liveAction {
			   Section {
				  VStack {
					 // MARK: Last Play & Bases card
					 HStack {
						if let lastPlay = event.lastPlay {  // is there a lastPlay
						   Text(lastPlay)
							  .onAppear {
								 addPlay(lastPlay)
							  }
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
									 inningTxt: event.inningTxt,
									 thisSubStrike:	event.thisSubStrike,
									 atBat: atBat ?? "N/A",
									 atBatPic: atBatPic ?? "N/A URL")
						}
					 }

			   } // end bases section
			} // end list
		 }
		 .frame(width: UIScreen.main.bounds.width, height: 600)

		 Spacer()

		 // MARK: // LastPlayHist list
		 VStack {
			Section {
			   ScrollView {
				  NavigationView {
					 List(Array(gameViewModel.lastPlayHist.reversed().enumerated()), id: \.1) { index, lastPlay in
						HStack {
						   Image(systemName: "baseball")
						   Text(lastPlay)
							  .font(index == 0 ? .body : .footnote)
							  .foregroundColor(index == 0 ? .green : .white)
							  .fontWeight(index == 0 ? .bold : .regular)
							  .minimumScaleFactor(0.5)
							  .scaledToFit()
						}
					 }
					 .toolbar {
						ToolbarItem(placement: .topBarLeading) {
						   Text("Batting: \(gameViewModel.filteredEvents.first?.atBat ?? "") - \(gameViewModel.filteredEvents.first?.atBatSummary ?? "")")
							  .font(.headline)
							  .foregroundColor(.blue)
						}
					 }
				  }
			   }
			   .font(.footnote)
			   //		 .frame(maxHeight: .infinity) // Ensure ScrollView uses all available space

			   .frame(width: UIScreen.main.bounds.width, height: 150)
			}
			}

		 VStack {
			Text("Version: \(getAppVersion())")
			   .font(.system(size: 10))
			   .padding(.bottom, 10)
		 }
		 VStack {
			pickTeam()
			   .frame(width: UIScreen.main.bounds.width, height: 20)
			   .padding(.top, -15)
		 }
	  }
	  .onAppear(perform: gameViewModel.loadData)

	  .onReceive(timer) { _ in
		 gameViewModel.loadData()
	  }

	  Button("Refresh") {
		 gameViewModel.loadData()
	  }
	  .font(.footnote)
	  .padding(4)

	  .background(Color.blue)
	  .foregroundColor(.white)
	  .clipShape(Capsule())
	  Spacer()

		 .preferredColorScheme(.dark)
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

   func addPlay(_ play: String) {
	  //		viewModel.lastPlayHist.append(play)
	  //		print("adding \(play) to lastPlayHist: \(play)")
   }

   func getAppVersion() -> String {
	  if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
		 return version
	  } else {
		 return "Unknown version"
	  }
   }

   func pickTeam() -> some View {
	  return Picker("Select a team:", selection: $selectedTeam) {
		 ForEach(teams, id: \.self) { team in
			Text(team).tag(team)
		 }
	  }
	  .pickerStyle(MenuPickerStyle())
	  .padding()
	  .background(Color.gray.opacity(0.2))
	  .cornerRadius(10)
	  .padding(.horizontal)

	  .onChange(of: selectedTeam) { newValue in
		 //			print("newValue: \(newValue)")
		 DispatchQueue.main.async {
			gameViewModel.lastPlayHist.removeAll() // clear the lastPlayHist
			gameViewModel.updateTeamPlaying(with: newValue)
			gameViewModel.teamPlaying = newValue
		 }
	  }
   }


}

#Preview {
   ContentView()
}
