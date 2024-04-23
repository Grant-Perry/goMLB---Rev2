//   ContentView.swift
//   goMLB
//
//   Created by: Grant Perry on 4/21/24 at 4:37 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

/// ViewModel responsible for loading and managing baseball event data.
class EventViewModel: ObservableObject {
   // Published array of filtered events based on specific criteria.
   @Published var filteredEvents: [EventDisplay] = []

   // Structure representing the displayable details of a baseball event.
   struct EventDisplay {
	  var title: String        // Full title of the event.
	  var shortTitle: String   // Shortened title of the event.
	  var home: String         // Home team name.
	  var visitors: String     // Visiting team name.
	  var homeRecord: String  //  Home team's season record
	  var visitorRecord: String  // Visitor's season record
	  var inning: Int          // Current inning number.
	  var homeScore: String    // Home team's current score.
	  var visitScore: String   // Visitor team's current score.
	  var homeColor: String 	// home colors
	  var visitorColor: String 	// visitors colors
	  var on1: Bool            // Runner on first base.
	  var on2: Bool            // Runner on second base.
	  var on3: Bool            // Runner on third base.
	  var lastPlay: String?    // Description of the last play.
	  var balls: Int?          // Current ball count.
	  var strikes: Int?        // Current strike count.
	  var outs: Int?           // Current out count.
   }

   /// Loads baseball event data from an API, filters it, and updates the view model.
   func loadData() {
	  // API URL for MLB scoreboard data.

 // MARK: Team Playing
	  let teamPlaying = "Yankees"

	  guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard") else { return }

	  URLSession.shared.dataTask(with: url) { data, response, error in
		 guard let data = data, error == nil else {
			print("Network error: \(error?.localizedDescription ?? "No error description")")
			return
		 }

		 do {
			// Decoding JSON into APIResponse structure.
			let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
			// Switches the execution context to the main thread.
			DispatchQueue.main.async {

			   // This line ensures that the UI update is performed on the main thread, which is crucial for any UI
			   // changes in iOS development to avoid UI freezing or crashes.

			   // teamPlaying holds the value to filter the list of events to include to only those where the name contains the value of teamPlaying.
			   // Then it maps the results to a new structure.

			   self.filteredEvents = decodedResponse.events.filter { $0.name.contains(teamPlaying) }.map { event in

				  // Filtering and Mapping: The filter method screens the events based on the condition that their names contain teamPlaying.
				  // This is followed by the map method, which transforms each filtered event into an EventDisplay object structured to
				  // fit the UI's needs. This includes extracting and simplifying data from nested structures (like competitors and situations).

				  // Accesses the current situation details of the first competition in each event.
				  let situation = event.competitions[0].situation  // holds the entire "situation" JSON tree
				  // Constructs a new EventDisplay object, mapping event data and situation data into a flat, displayable structure.
				  let homeCompetitor = event.competitions[0].competitors[0] // holds the entire home "competitors" JSON tree
				  let visitorCompetitor = event.competitions[0].competitors[1] // holds the entire visitor "competitors" JSON tree
				  return EventDisplay(
					 title: event.name,  // Sets the full title of the event.
					 shortTitle: event.shortName,  // Sets a shorter title for the event.
					 home: event.competitions[0].competitors[0].team.name,  // Sets the home team name using the first competitor's team name.
					 visitors: event.competitions[0].competitors[1].team.name,  // Sets the visiting team name using the second competitor's team name.
					 homeRecord: homeCompetitor.records.first?.summary ?? "0-0", // set the home season record
					 visitorRecord: visitorCompetitor.records.first?.summary ?? "0-0", // set the away season record
					 inning: event.status.period,  // Sets the current inning number from the event status.
					 homeScore: event.competitions[0].competitors[0].score ?? "0",  // Sets the home team's score, defaulting to "0" if null.
					 visitScore: event.competitions[0].competitors[1].score ?? "0",  // Sets the visiting team's score, defaulting to "0" if null.
					 homeColor: event.competitions[0].competitors[0].team.color,
					 visitorColor: event.competitions[0].competitors[1].team.color,
					 on1: situation?.onFirst ?? false,  // Indicates if there is a runner on first base, defaulting to false if null.
					 on2: situation?.onSecond ?? false,  // Indicates if there is a runner on second base, defaulting to false if null.
					 on3: situation?.onThird ?? false,  // Indicates if there is a runner on third base, defaulting to false if null.
					 lastPlay: situation?.lastPlay?.text ?? "N/A",  // Sets the text of the last play, defaulting to "N/A" if null.
					 balls: situation?.balls ?? 0,  // Sets the current number of balls, defaulting to 0 if null.
					 strikes: situation?.strikes ?? 0,  // Sets the current number of strikes, defaulting to 0 if null.
					 outs: situation?.outs ?? 0  // Sets the current number of outs, defaulting to 0 if null.
				  )
			   }
			}
		 } catch {
			print("Error decoding JSON: \(error)")
		 }
	  }.resume()
   }
}

struct ContentView: View {
   @ObservedObject var viewModel = EventViewModel()
   let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
   let scoreColor = Color(.blue)
   let winners = Color(.green)
   let scoreSize = 50.0
   let titleSize = 25.0

   var body: some View {
	  VStack {
		 List(viewModel.filteredEvents, id: \.title) { event in
			let home = viewModel.filteredEvents.first?.home
			let visitors = viewModel.filteredEvents.first?.visitors
			let visitScore = viewModel.filteredEvents.first?.visitScore ?? "0"
			let homeScore = viewModel.filteredEvents.first?.homeScore ?? "0"
			let homeWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0) ? true : false
			let homeColor = viewModel.filteredEvents.first?.homeColor
			let visitColor = viewModel.filteredEvents.first?.visitorColor
			let winColor = Color.green

			VStack(spacing: 0) {
 //	MARK: Title Tile
			   HStack(alignment: .center) {
				  VStack(spacing: 0) {  // Remove spacing between VStack elements
					 Text("\(home ?? "")")
						.font(.system(size: scoreSize))
						.foregroundColor(Color(hex: homeColor ?? "000000"))
						.multilineTextAlignment(.center)

					 Text("vs.")
						.font(.footnote)
						.multilineTextAlignment(.center)
						.padding(.vertical, 2)  // Minimal padding to reduce space

					 Text("\(visitors ?? "")")
						.font(.system(size: scoreSize))
						.foregroundColor(Color(hex: visitColor ?? "000000"))
						.multilineTextAlignment(.center)
				  }
				  .frame(maxWidth: .infinity, maxHeight: 120)
				  .multilineTextAlignment(.center)
				  .padding()
				  .lineSpacing(0)  // Set line spacing to be very tight
			   }
			   .font(.system(size: 20))
			   .padding()
//			   .lineLimit(2)
			   .minimumScaleFactor(0.15)
			   .scaledToFit()

// MARK: Scores
			   HStack(spacing: 0) {
		 // First column for visitor's score (Right justified)
				  Text("\(viewModel.filteredEvents.first?.visitScore ?? "0")")
					 .font(.system(size: scoreSize).weight(.bold))
					 .frame(width: UIScreen.main.bounds.width * 0.15, alignment: .trailing)
					 .foregroundColor(homeWin ? winColor : .blue)
//					 .padding(.leading)

		 // Second column for visitor's name and record
				  VStack(alignment: .leading) {
					 Text("\(viewModel.filteredEvents.first?.visitors ?? "")")
						.font(.title2)
						.foregroundColor(Color(hex: visitColor ?? "000000"))
					 Text("\(viewModel.filteredEvents.first?.visitorRecord ?? "")")
						.font(.caption)
						.foregroundColor(.gray)
				  }
				  .frame(width: UIScreen.main.bounds.width * 0.35)

				  // Third column for home's name and record
				  VStack(alignment: .leading) {
					 Text("\(viewModel.filteredEvents.first?.home ?? "")")
						.font(.title2)
						.foregroundColor(Color(hex: homeColor ?? "000000"))

					 Text("\(viewModel.filteredEvents.first?.homeRecord ?? "")")
						.font(.caption)
						.foregroundColor(.gray)
				  }
				  .frame(width: UIScreen.main.bounds.width * 0.35)

				  // Fourth column for home's score (Left justified)
				  Text("\(viewModel.filteredEvents.first?.homeScore ?? "")")
					 .font(.system(size: scoreSize).weight(.bold))
					 .frame(width: UIScreen.main.bounds.width * 0.15, alignment: .leading)
					 .foregroundColor(.blue)
			   }

			   HStack {
				 
				  if let lastPlay = event.lastPlay {
					 Text("Last Play: \(lastPlay)")
				  }
			   }
			   Spacer()

			   // Bases View on the left
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
			   }
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
	  

	  .onAppear(perform: viewModel.loadData)
	  .onReceive(timer) { _ in
		 viewModel.loadData()
	  }

//	  .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
   }


}





#Preview {
   ContentView()
}
