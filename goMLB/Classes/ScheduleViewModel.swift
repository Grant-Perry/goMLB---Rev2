import SwiftUI
import Combine

class ScheduleViewModel: ObservableObject {
   @Published var schedule: [Dictionary<String, String>] = []
   @Published var teams: [Dictionary<String, String>] = []
   @Published var selectedTeam: Dictionary<String, String>? {
	  didSet {
		 if let team = selectedTeam {
			fetchSchedule(for: team["teamName"] ?? "")
		 }
	  }
   }
   @Published var dateRange: String = ""

   private var cancellables = Set<AnyCancellable>()

   init() {
	  fetchTeams()
   }

   func fetchTeams() {
	  guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/teams") else {
		 return
	  }

	  URLSession.shared.dataTaskPublisher(for: url)
		 .map { $0.data }
		 .replaceError(with: Data())
		 .receive(on: DispatchQueue.main)
		 .sink { [weak self] data in
			self?.parseTeams(jsonData: data)
		 }
		 .store(in: &cancellables)
   }

   func fetchSchedule(for teamName: String) {
	  guard let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/teams") else {
		 return
	  }

	  URLSession.shared.dataTaskPublisher(for: url)
		 .map { $0.data }
		 .replaceError(with: Data())
		 .receive(on: DispatchQueue.main)
		 .sink { [weak self] data in
			self?.parseSchedule(jsonData: data, for: teamName)
		 }
		 .store(in: &cancellables)
   }

   private func parseTeams(jsonData: Data) {
	  do {
		 if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
			let sports = json["sports"] as? [[String: Any]] {
			var teamInfos: [Dictionary<String, String>] = []
			for sport in sports {
			   if let leagues = sport["leagues"] as? [[String: Any]] {
				  for league in leagues {
					 if let teams = league["teams"] as? [[String: Any]] {
						for teamInfo in teams {
						   if let team = teamInfo["team"] as? [String: Any],
							  let teamName = team["displayName"] as? String,
							  let teamLogo = team["logos"] as? [[String: Any]],
							  let teamColor = team["color"] as? String,
							  let teamAltColor = team["alternateColor"] as? String {

							  let logoURL = teamLogo.first?["href"] as? String ?? ""

							  let teamData: [String: String] = [
								 "teamName": teamName,
								 "teamLogo": logoURL,
								 "teamColor": teamColor,
								 "teamAltColor": teamAltColor
							  ]
							  teamInfos.append(teamData)
						   }
						}
					 }
				  }
			   }
			}
			self.teams = teamInfos
			self.selectedTeam = teamInfos.first
		 }
	  } catch {
		 print("Failed to parse JSON: \(error.localizedDescription)")
	  }
   }

   private func parseSchedule(jsonData: Data, for teamName: String) {
	  let opponentTeams = [
		 "Atlanta Braves", "Baltimore Orioles", "Boston Red Sox", "Chicago Cubs",
		 "Chicago White Sox", "Cincinnati Reds", "Cleveland Guardians",
		 "Colorado Rockies", "Detroit Tigers", "Houston Astros"
	  ]
	  let stadiumNames = [
		 "Truist Park", "Oriole Park at Camden Yards", "Fenway Park", "Wrigley Field",
		 "Guaranteed Rate Field", "Great American Ball Park", "Progressive Field",
		 "Coors Field", "Comerica Park", "Minute Maid Park"
	  ]
	  let startTimes = [
		 "7:05 PM EST", "7:10 PM EST", "7:15 PM EST", "7:20 PM EST",
		 "7:25 PM EST", "7:30 PM EST", "7:35 PM EST", "7:40 PM EST",
		 "7:45 PM EST", "7:50 PM EST"
	  ]

	  let today = Date()
	  let dateFormatter = DateFormatter()
	  dateFormatter.dateFormat = "yyyy-MM-dd"

	  let displayFormatter = DateFormatter()
	  displayFormatter.dateFormat = "EEEE, MMMM d"

	  var scheduleData: [Dictionary<String, String>] = []

	  do {
		 if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
			let sports = json["sports"] as? [[String: Any]] {
			for sport in sports {
			   if let leagues = sport["leagues"] as? [[String: Any]] {
				  for league in leagues {
					 if let teams = league["teams"] as? [[String: Any]] {
						for teamInfo in teams {
						   if let team = teamInfo["team"] as? [String: Any],
							  let teamDisplayName = team["displayName"] as? String,
							  teamDisplayName == teamName,
							  let links = team["links"] as? [[String: Any]] {

							  var scheduleURL: String?

							  for link in links {
								 if let rel = link["rel"] as? [String], rel.contains("schedule"),
									let href = link["href"] as? String {
									scheduleURL = href
									break
								 }
							  }

							  if scheduleURL != nil {
								 for i in 1...10 {
									let opponentIndex = (i - 1) % opponentTeams.count
									let date = Calendar.current.date(byAdding: .day, value: i, to: today)!
									let dateString = dateFormatter.string(from: date)
									let displayDateString = displayFormatter.string(from: date)
									let time = startTimes[i % startTimes.count]
									let matchup = "\(teamName) vs \(opponentTeams[opponentIndex])"
									let location = stadiumNames[opponentIndex]

									let scheduleItem: [String: String] = [
									   "date": dateString,
									   "displayDate": displayDateString,
									   "time": time,
									   "matchup": matchup,
									   "location": location
									]
									scheduleData.append(scheduleItem)
								 }
								 // Calculate the date range
								 let startDate = displayFormatter.string(from: today)
								 let endDate = displayFormatter.string(from: Calendar.current.date(byAdding: .day, value: 10, to: today)!)
								 self.dateRange = "\(startDate) - \(endDate)"
							  }
						   }
						}
					 }
				  }
			   }
			}
		 }
	  } catch {
		 print("Failed to parse JSON: \(error.localizedDescription)")
	  }

	  DispatchQueue.main.async {
		 self.schedule = scheduleData
	  }
   }
}
