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
	@ObservedObject var viewModel = EventViewModel()
	let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
	let scoreColor = Color(.blue)
	let winners = Color(.green)

	let scoreSize = 40.0
	let titleSize = 35.0
	let logoWidth = 90.0

	let teams = ["Arizona Diamondbacks", "Atlanta Braves", "Baltimore Orioles", "Boston Red Sox",
					 "Chicago Cubs", "Chicago White Sox", "Cincinnati Reds", "Cleveland Guardians",
					 "Colorado Rockies", "Detroit Tigers", "Houston Astros", "Kansas City Royals",
					 "Los Angeles Angels", "Los Angeles Dodgers", "Miami Marlins", "Milwaukee Brewers",
					 "Minnesota Twins", "New York Mets", "New York Yankees", "Oakland Athletics",
					 "Philadelphia Phillies", "Pittsburgh Pirates", "San Diego Padres", "San Francisco Giants",
					 "Seattle Mariners", "St. Louis Cardinals", "Tampa Bay Rays", "Texas Rangers",
					 "Toronto Blue Jays", "Washington Nationals"]
	@State var selectedTeam = "New York Yankees"

	var body: some View {
		VStack {
			List(viewModel.filteredEvents, id: \.ID) { event in
				let home = viewModel.filteredEvents.first?.home
				let visitors = viewModel.filteredEvents.first?.visitors
				let visitScore = viewModel.filteredEvents.first?.visitScore ?? "0"
				let homeScore = viewModel.filteredEvents.first?.homeScore ?? "0"
				let homeWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) ? false : true
				let visitWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) ? true : false
				let homeColor = viewModel.filteredEvents.first?.homeColor
				let visitColor = viewModel.filteredEvents.first?.visitorColor
				let winColor = Color.green

				//				Spacer()
				VStack(spacing: 0) {
					//	MARK: Title / Header Tile
					HStack(alignment: .center) {
						VStack(spacing: -4) {  // Remove spacing between VStack elements

							Text("\(home ?? "")")
								.font(.system(size: titleSize))
								.foregroundColor(Color(hex: homeColor ?? "000000"))
								.multilineTextAlignment(.center)

							Text("vs.")
								.font(.footnote)
								.multilineTextAlignment(.center)
								.padding(.vertical, 2)  // Minimal padding to reduce space

							Text("\(visitors ?? "")")
								.font(.system(size: titleSize))
								.foregroundColor(Color(hex: visitColor ?? "000000"))
								.multilineTextAlignment(.center)
						}
						//						.frame(width: .infinity, height: 250)
						.multilineTextAlignment(.center)
						.padding()
						.lineSpacing(0)
					}
					.padding(.top,30)
					.frame(width: UIScreen.main.bounds.width, height: 150)
					.minimumScaleFactor(0.25)
					.scaledToFit()

					// MARK: Scores card

					// MARK: First column - visitor's score (Right justified)
					HStack(spacing: 0) {
						Text("\(visitScore)")
							.font(.system(size: scoreSize).weight(.bold))
							.frame(width: UIScreen.main.bounds.width * 0.15, alignment: .trailing)
							.foregroundColor(visitWin && Int(visitScore) ?? 0 > 0 ? winColor : .blue)

						// MARK: Second column - visitor's name and record
						VStack(alignment: .leading) {
							Text("\(visitors ?? "")")
								.font(.title3)
								.foregroundColor(Color(hex: visitColor ?? "000000"))
							Text("\(viewModel.filteredEvents.first?.visitorRecord ?? "")")
								.font(.caption)
								.foregroundColor(.gray)
							VStack(alignment: .leading) {
								TeamIconView(teamColor: visitColor ?? "C4CED3", teamIcon: event.visitorLogo)
									.clipShape(Circle())
							}
						}
						.frame(width: UIScreen.main.bounds.width * 0.35)

						// MARK: Third column - home's name and record
						VStack(alignment: .trailing) {
							Text("\(home ?? "")")
								.font(.title3)
								.foregroundColor(Color(hex: homeColor ?? "000000"))

							Text("\(viewModel.filteredEvents.first?.homeRecord ?? "")")
								.font(.caption)
								.foregroundColor(.gray)
							VStack(alignment: .leading) {
								TeamIconView(teamColor: homeColor ?? "C4CED3", teamIcon: event.homeLogo)
									.frame(width: logoWidth)
									.clipShape(Circle())
							}
						}
						.frame(width: UIScreen.main.bounds.width * 0.35)

						// MARK: Fourth column - HOME SCORE
						Text("\(homeScore)")
							.font(.system(size: scoreSize).weight(.bold))
							.frame(width: UIScreen.main.bounds.width * 0.15, alignment: .leading)
							.foregroundColor(homeWin && Int(homeScore) ?? 0 > 0 ? winColor : .blue)

							.padding(.trailing)
					}
					.padding()
					.frame(width: UIScreen.main.bounds.width, height: 110) // for the score card

					VStack {

 // MARK: Last Play & Bases card
						HStack {
							if let lastPlay = event.lastPlay {  // is there a lastPlay
								Text(lastPlay)
									.onAppear {
										addPlay(lastPlay)
									}
									.lineLimit(2)
									.minimumScaleFactor(0.25)
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
										 inningTxt: event.inningTxt )
						}
//						HStack {
//							Text("Inning: \(event.inningTxt)")
//								.font(.caption)
//						}
					}
				}
			}
			.frame(width: UIScreen.main.bounds.width, height: 425)
			.background(.green)
			Spacer()


			// MARK: // LastPlayHist list
			ScrollView {
				NavigationView {
					List(viewModel.lastPlayHist.reversed(), id: \.self) { lastPlay in
						HStack {
							Image(systemName: "baseball")
							Text(lastPlay)
						}
					}
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							Text("Play History")
								.font(.headline) // Smaller font style
								.foregroundColor(.primary)
							//							  .background(.green)
						}
					}
//					.padding(.top, -30)
				}

			}

			Button("Refresh") {
				viewModel.loadData()
			}
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.clipShape(Capsule())
		}

		.safeAreaInset(edge: .bottom) {
			Picker("Select a team:", selection: $selectedTeam) {
				ForEach(teams, id: \.self) { team in
					Text(team).tag(team)
				}
			}
			.pickerStyle(MenuPickerStyle())
			.onChange(of: selectedTeam) { newValue in
				//			print("newValue: \(newValue)")
				DispatchQueue.main.async {
					viewModel.lastPlayHist.removeAll() // clear the lastPlayHist
					viewModel.updateTeamPlaying(with: newValue)
					viewModel.teamPlaying = newValue
					//			   viewModel.loadData()
				}
			}
		}
		.onAppear(perform: viewModel.loadData)

		.onReceive(timer) { _ in
			viewModel.loadData()
			print("Updating Timer")

		}
		.preferredColorScheme(.light)
	}

	func addPlay(_ play: String) {
		//		viewModel.lastPlayHist.append(play)
		print("adding \(play) to lastPlayHist: \(play)")
	}

}

#Preview {
	ContentView()
}
