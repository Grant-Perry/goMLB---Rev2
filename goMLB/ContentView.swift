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
	@State var lastPlayHist: [String] = []
   let scoreSize = 40.0
   let titleSize = 35.0

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
		  List(viewModel.filteredEvents, id: \.title) { event in
			  let home = viewModel.filteredEvents.first?.home
			  let visitors = viewModel.filteredEvents.first?.visitors
			  let visitScore = viewModel.filteredEvents.first?.visitScore ?? "0"
			  let homeScore = viewModel.filteredEvents.first?.homeScore ?? "0"
			  let homeWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) ? false : true
			  let visitWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) ? true : false
			  let homeColor = viewModel.filteredEvents.first?.homeColor
			  let visitColor = viewModel.filteredEvents.first?.visitorColor
			  let winColor = Color.green

			  VStack(spacing: 0) {
//	MARK: Title / Header Tile
				  HStack(alignment: .center) {
					  VStack(spacing: 0) {  // Remove spacing between VStack elements

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
					  .frame(maxWidth: .infinity, maxHeight: 120)
					  .multilineTextAlignment(.center)
					  .padding()
					  .lineSpacing(0)
				  }
				  .frame(width: .infinity, height: 150)
				  //			   .font(.system(size: 20))
//				  .padding()
				  //			   .lineLimit(2)
//				  .minimumScaleFactor(0.15)
//				  .scaledToFit()

// MARK: Scores
				  HStack(spacing: 0) {
					  // First column for visitor's score (Right justified)
					  Text("\(viewModel.filteredEvents.first?.visitScore ?? "0")")
						  .font(.system(size: scoreSize).weight(.bold))
						  .frame(width: UIScreen.main.bounds.width * 0.15, alignment: .trailing)
						  .foregroundColor(visitWin ? winColor : .blue)

 // MARK: Second column - visitor's name and record
					  VStack(alignment: .leading) {
						  Text("\(visitors ?? "")")
							  .font(.title2)
							  .foregroundColor(Color(hex: visitColor ?? "000000"))
						  Text("\(viewModel.filteredEvents.first?.visitorRecord ?? "")")
							  .font(.caption)
							  .foregroundColor(.gray)
						  VStack(alignment: .leading) {
							  AsyncImage(url: URL(string: event.visitorLogo)) { image in
								  image.resizable().scaledToFit()
							  } placeholder: {
								  Color.gray
							  }
							  .frame(width: 30)
							  .clipShape(Circle())
						  }
					  }
					  .frame(width: UIScreen.main.bounds.width * 0.35)

					  // MARK: Third column - home's name and record
					  VStack(alignment: .trailing) {
						  Text("\(home ?? "")")
							  .font(.title2)
							  .foregroundColor(Color(hex: homeColor ?? "000000"))

						  Text("\(viewModel.filteredEvents.first?.homeRecord ?? "")")
							  .font(.caption)
							  .foregroundColor(.gray)
						  VStack(alignment: .leading) {
							  AsyncImage(url: URL(string: event.homeLogo)) { image in
								  image.resizable().scaledToFit()
							  } placeholder: {
								  Color.gray
							  }
							  .frame(width: 30)
							  .clipShape(Circle())
						  }
					  }
					  .frame(width: UIScreen.main.bounds.width * 0.35)

 // MARK: Fourth column home's score (Left justified)
					  Text("\(viewModel.filteredEvents.first?.homeScore ?? "")")
						  .font(.system(size: scoreSize).weight(.bold))
						  .frame(width: UIScreen.main.bounds.width * 0.15, alignment: .leading)
						  .foregroundColor(homeWin ? winColor : .blue)
						  .padding(.trailing)
				  }

				  VStack {
					  HStack {
						  if let lastPlay = event.lastPlay {  // is there a lastPlay
//							  Text("Last Play: \(lastPlay)")
							  Text("")
								  .onAppear {
									  addPlay(lastPlay)
								  }
								  .lineLimit(2)
								  .minimumScaleFactor(0.25)
								  .scaledToFit()
						  }

					  }

//					  Spacer()

 // MARK: Bases View

					  HStack {
						  BasesView(onFirst: event.on1,
										onSecond: event.on2,
										onThird: event.on3,
										strikes: event.strikes ?? 0,
										balls: event.balls ?? 0,
										outs: event.outs ?? 0)
					  }
					  HStack {
						  Text("Inning: \(event.inning)")
							  .font(.caption)
					  }
				  }
				  .padding(.top, -5)
			  }
			  .frame(width: .infinity, height:300)
		  }
			  // MARK: // LastPlayHist list
			  		  ScrollView {
			  		  	NavigationView {
			  				  List(lastPlayHist, id: \.self) { lastPlay in
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
			  				  .padding(.top, -30)
			  			  }

			  		  }

		 Button("Refresh") {
			 lastPlayHist.removeAll()
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
			print("newValue: \(newValue)")
			DispatchQueue.main.async {
			   viewModel.updateTeamPlaying(with: newValue)
			   viewModel.teamPlaying = newValue
				lastPlayHist.removeAll() // clear the lastPlayHist
//			   viewModel.loadData()
			}
		 }
	  }

	  .onAppear(perform: viewModel.loadData)
	  .onReceive(timer) { _ in
		 viewModel.loadData()
	  }

	  	  .preferredColorScheme(.light)
   }
	func addPlay(_ play: String) {
		lastPlayHist.append(play)
	}

}

#Preview {
   ContentView()
}
