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
	  var inning: Int          // Current inning number.
	  var homeScore: String    // Home team's current score.
	  var visitScore: String   // Visitor team's current score.
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
			   let teamPlaying = "Reds"
			   self.filteredEvents = decodedResponse.events.filter { $0.name.contains(teamPlaying) }.map { event in

				  // Filtering and Mapping: The filter method screens the events based on the condition that their names contain "Yankees". This
				  // is followed by the map method, which transforms each filtered event into an EventDisplay object structured to fit the UI's needs.
				  // This includes extracting and simplifying data from nested structures (like competitors and situations).

				  // Accesses the current situation details of the first competition in each event.
				  let situation = event.competitions[0].situation
				  // Constructs a new EventDisplay object, mapping event data and situation data into a flat, displayable structure.
				  return EventDisplay(
					 title: event.name,  // Sets the full title of the event.
					 shortTitle: event.shortName,  // Sets a shorter title for the event.
					 home: event.competitions[0].competitors[0].team.name,  // Sets the home team name using the first competitor's team name.
					 visitors: event.competitions[0].competitors[1].team.name,  // Sets the visiting team name using the second competitor's team name.
					 inning: event.status.period,  // Sets the current inning number from the event status.
					 homeScore: event.competitions[0].competitors[0].score ?? "0",  // Sets the home team's score, defaulting to "0" if null.
					 visitScore: event.competitions[0].competitors[1].score ?? "0",  // Sets the visiting team's score, defaulting to "0" if null.
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

   var body: some View {
	  VStack {
		 List(viewModel.filteredEvents, id: \.title) { event in
			Spacer()
			VStack{
			   HStack(alignment: .center) {
				  Text(event.title).font(.headline)
			   }
			   Spacer()

			   HStack {
				  Spacer()
				  HStack {
					 // First column for visitor's score
					 Text("\(viewModel.filteredEvents.first?.visitScore ?? "")")
						.font(.system(size: 45).weight(.bold))
						.frame(width: UIScreen.main.bounds.width * 0.1, alignment: .leading)
						.foregroundColor(.white)
						.padding(.leading).padding(.leading)

					 // Second column for visitor's name
					 Text("\(viewModel.filteredEvents.first?.visitors ?? "")")
						.font(.title2)
						.frame(width: UIScreen.main.bounds.width * 0.3, alignment: .leading)
						.foregroundColor(.gray)

					 // Fourth column for home's name
					 Text("\(viewModel.filteredEvents.first?.home ?? "")")
						.font(.title2)
						.frame(width: UIScreen.main.bounds.width * 0.3, alignment: .leading)
						.foregroundColor(.gray)

					 // Third column for home's score
					 Text("\(viewModel.filteredEvents.first?.homeScore ?? "")")
						.font(.system(size: 45).weight(.bold))
						.frame(width: UIScreen.main.bounds.width * 0.1, alignment: .leading)
						.foregroundColor(.white)
						.padding(.trailing)
				  }
			   }
			   Spacer()
			   HStack {

				  Text("Inning: \(event.inning)")
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
			   .frame(width: .infinity )
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
	  .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
   }

}





#Preview {
   ContentView()
}
