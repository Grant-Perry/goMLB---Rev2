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
	@State var selectedTeam = "Arizona Diamondbacks"

	let timerValue = 15

	let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
	let fakeTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	let scoreColor = Color(.blue)
	let winners = Color(.green)


	let scoreSize = 55.0
	let titleSize = 35.0
	let logoWidth = 90.0
	let version = "99.8"
	let tooDark = "#333333"

	//	var teams = MLBTeams.teams

	var body: some View {
		VStack(spacing: -15) {
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
				//			let atBatSummary = vm?.atBatSummary
				let winColor = Color.green
				let liveAction: Bool = true // event.inningTxt.lowercased().contains("Start") || event.inningTxt.lowercased().contains("Sch")
													 //			let midInning: Bool = event.inningTxt.lowercased().contains("Top") || event.inningTxt.lowercased().contains("Bottom")


				//	MARK: Title / Header Tile
				VStack {

					Section {
						VStack(spacing: 0) {

							HStack(alignment: .center) {
								VStack(spacing: -4) {  // Remove spacing between VStack elements

									HStack(spacing: -4) {
										Spacer()
										HStack {
											Text("\(visitors ?? "")")
												.font(.system(size: titleSize))
												.foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
												.frame(width: 150, alignment: .trailing)
												.lineLimit(1)
												.minimumScaleFactor(0.5)
										}
										HStack {
											Text("vs")
												.font(.footnote)
											//									  .multilineTextAlignment(.center)
												.padding(.vertical, 2)
												.frame(width: 40)
										}

										HStack {
											Text("\(home ?? "")")
												.font(.system(size: titleSize))
												.foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
												.frame(width: 150, alignment: .leading)
												.lineLimit(1)
												.minimumScaleFactor(0.5)

										}
										Spacer()
									}

									if (inningTxt?.contains("Scheduled") ?? false ) {
										Text("\nStarting: \(startTime ?? "")")
											.font(.system(size: 14))
											.foregroundColor(.white)
									}
									else {
										Text("\(inningTxt ?? "")")
											.font(.system(size: 14))
											.foregroundColor(.white)
											.padding(.top, 5)
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

									Button(action: {
										refreshGame.toggle() // Toggle the state of refreshGame on click
									}) {
										Text((refreshGame ? "Updating" : "Not Updating") + "\n")
											.foregroundColor(refreshGame ? .green : .red) // Change color based on refreshGame
											.font(.caption) // Set the font size
											.frame(width: 200, height: 22, alignment: .trailing) // Frame for the text, right aligned
											.padding(.trailing) // Padding inside the button to the right

										// MARK: updating time remaining
											.onReceive(fakeTimer) { _ in
												if self.thisTimeRemaining > 0 {
													self.thisTimeRemaining -= 1
												} else  {
													self.thisTimeRemaining = 15
												}
											}

										if refreshGame {
											timerRemaingView(timeRemaining: $thisTimeRemaining)
												.font(.system(size: 20))
												.frame(width: 200, height: 11, alignment: .trailing) // Frame for the text, right aligned
												.padding(.top, -17)
										}
									}
									.frame(maxWidth: .infinity, alignment: .trailing) // Ensure the button itself is right-aligned
									.padding(.trailing, 20) // Padding from the right edge of the container
									.cornerRadius(10) // Rounded corners for the button
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
					.frame(width: UIScreen.main.bounds.width, height: 120, alignment: .trailing)
					.cornerRadius(10)
					//			}
					//
					//
					//			// MARK: Scores card
					//			// MARK: First column - visitor's score (Right justified)
					//
					//			Section {
					//			   HStack(spacing: 0) {
					//				  // MARK: NEW head Away vs Home
					//					HStack {
					//					 HStack {
					//						Text("\(visitors ?? "")")
					//						   .font(.title3)
					//						   .frame(width: UIScreen.main.bounds.width * 0.95 / 2, height: 30, alignment: .trailing)
					//						   .minimumScaleFactor(0.5)
					//						   .lineLimit(1)
					//						   .foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
					//						   .padding()
					//						   .border(.white)
					//					 }
					//					 Spacer()
					//
					//					 HStack {
					//						Text("\(home ?? "")")
					//						   .font(.title3)
					//						   .frame(width: UIScreen.main.bounds.width / 2, height: 30, alignment: .leading)
					//						   .minimumScaleFactor(0.5)
					//						   .lineLimit(1)
					//						   .foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
					//					 }
					//
					//				  }
					//			   }
					//			   .frame(maxWidth: .infinity, maxHeight: 20, alignment: .trailing)
					//			   .border(.green)

					HStack(spacing: 0) {
						// MARK: Visitor's Side
						HStack { // Visitor Side
							VStack(alignment: .leading, spacing: 0) {
								VStack {
									Text("\(visitors ?? "")")
										.font(.title3)

										.minimumScaleFactor(0.5)
										.lineLimit(1)
										.frame(width: 110, alignment: .leading)
										.foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))
									//							  .border(.red)

									Text("\(vm?.visitorRecord ?? "")")
										.font(.caption)
										.foregroundColor(.gray)
									Spacer()
								}
								VStack {
									HStack { // Aligns content to the trailing edge (right)
										Spacer()
										TeamIconView(teamColor: visitColor ?? "C4CED3", teamIcon: event.visitorLogo)
											.clipShape(Circle())
									}
									.frame(width: 90, alignment: .leading)
								}
							}
							// MARK: Visitor Score
							Text("\(visitScore)")
								.font(.system(size: scoreSize))
								.padding(.trailing)
								.foregroundColor(visitWin && Int(visitScore) ?? 0 > 0 ? winColor : Color(hex: visitColor!))
						} // end Visitor Side
						.frame(maxWidth: .infinity, alignment: .trailing)
						//				  .border(.green)

						// MARK: HOME (right) side
						HStack { // Home side
							Text("\(homeScore)")
								.font(.system(size: scoreSize))
								.padding(.leading)
								.foregroundColor(homeWin && Int(homeScore) ?? 0 > 0 ? winColor : Color(hex: homeColor!))


							VStack(alignment: .leading) {
								VStack {
									Text("\(home ?? "")")
										.font(.title3)
										.foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
										.minimumScaleFactor(0.5)
										.lineLimit(1)

									Text("\(vm?.homeRecord ?? "")")
										.font(.caption)
										.foregroundColor(.gray)
								}

								VStack {
									HStack { // Aligns content to the trailing edge (right)
												//							  Spacer()
										TeamIconView(teamColor: homeColor ?? "C4CED3", teamIcon: event.homeLogo)
											.clipShape(Circle())
									}
									.frame(width: 90, alignment: .trailing)
									//						   .border(.green)
								}
							}

						} // end Home side
						.frame(maxWidth: .infinity, alignment: .leading)
						//				  .border(.red)

					} // end Visitor Home sides
					.frame(width: UIScreen.main.bounds.width, height: 110)
					//			   .border(.blue)


				}  // full card
				.frame(width: UIScreen.main.bounds.width  * 0.9, height: .infinity) // for the score card
																										  //			.padding()
																										  //			.border(.red)

				if liveAction {
					//			   Section {
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

					//			   } // end bases section
				} // end list
			}
			.frame(width: UIScreen.main.bounds.width, height: 580)
			//		 .border(.green)
			//		 Spacer()

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

									Text("\(Image(systemName: "figure.baseball")) \(gameViewModel.filteredEvents.first?.atBat ?? "")\(gameViewModel.filteredEvents.first?.atBatSummary ?? "")")
										.font(.headline)
										.foregroundColor(.blue)
								}
							}
						}
					}
					.font(.footnote)
					//		 .frame(maxHeight: .infinity) // Ensure ScrollView uses all available space

					.frame(width: UIScreen.main.bounds.width, height: 150)
					.border(.red)
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
			if self.refreshGame {
				gameViewModel.loadData()
			}
			self.thisTimeRemaining = timerValue
		}

		Button("Refresh") {
			gameViewModel.loadData()
		}
		.font(.footnote)
		.padding(4)

		.background(Color.blue)
		.foregroundColor(.white)
		.clipShape(Capsule())
		//	  Spacer()

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
