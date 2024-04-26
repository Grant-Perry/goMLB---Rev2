//   teamNames.swift
//   goMLB
//
//   Created by: Gp. on 4/26/24 at 8:15 AM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import Foundation

struct MLBTeams: Hashable, Identifiable {
	let id: UUID = UUID() // Make id a constant property initialized once.
	let teamName: String
}
	let teams = ["Arizona Diamondbacks", "Atlanta Braves", "Baltimore Orioles", "Boston Red Sox",
					 "Chicago Cubs", "Chicago White Sox", "Cincinnati Reds", "Cleveland Guardians",
					 "Colorado Rockies", "Detroit Tigers", "Houston Astros", "Kansas City Royals",
					 "Los Angeles Angels", "Los Angeles Dodgers", "Miami Marlins", "Milwaukee Brewers",
					 "Minnesota Twins", "New York Mets", "New York Yankees", "Oakland Athletics",
					 "Philadelphia Phillies", "Pittsburgh Pirates", "San Diego Padres", "San Francisco Giants",
					 "Seattle Mariners", "St. Louis Cardinals", "Tampa Bay Rays", "Texas Rangers",
					 "Toronto Blue Jays", "Washington Nationals"]


//	let abbreviation: String
	let teamsAr = [
		MLBTeams(teamName: "Arizona Diamondbacks"),
		MLBTeams(teamName: "Atlanta Braves"),
		MLBTeams(teamName: "Baltimore Orioles"),
		MLBTeams(teamName: "Boston Red Sox"),
		MLBTeams(teamName: "Chicago Cubs"),
		MLBTeams(teamName: "Chicago White Sox"),
		MLBTeams(teamName: "Cincinnati Reds"),
		MLBTeams(teamName: "Cleveland Guardians"),
		MLBTeams(teamName: "Colorado Rockies"),
		MLBTeams(teamName: "Detroit Tigers"),
		MLBTeams(teamName: "Houston Astros"),
		MLBTeams(teamName: "Kansas City Royals"),
		MLBTeams(teamName: "Los Angeles Angels"),
		MLBTeams(teamName: "Los Angeles Dodgers"),
		MLBTeams(teamName: "Miami Marlins"),
		MLBTeams(teamName: "Milwaukee Brewers"),
		MLBTeams(teamName: "Minnesota Twins"),
		MLBTeams(teamName: "New York Mets"),
		MLBTeams(teamName: "New York Yankees"),
		MLBTeams(teamName: "Oakland Athletics"),
		MLBTeams(teamName: "Philadelphia Phillies"),
		MLBTeams(teamName: "Pittsburgh Pirates"),
		MLBTeams(teamName: "San Diego Padres"),
		MLBTeams(teamName: "San Francisco Giants"),
		MLBTeams(teamName: "Seattle Mariners"),
		MLBTeams(teamName: "St. Louis Cardinals"),
		MLBTeams(teamName: "Tampa Bay Rays"),
		MLBTeams(teamName: "Texas Rangers"),
		MLBTeams(teamName: "Toronto Blue Jays"),
		MLBTeams(teamName: "Washington Nationals")
]
