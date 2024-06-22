//   ScheduleView.swift
//   goMLB
//
//   Created by: Grant Perry on 6/22/24 at 11:56 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct ScheduleView: View {
   @ObservedObject var viewModel = ScheduleViewModel()

   var body: some View {
	  VStack {
		 if viewModel.teams.isEmpty {
			ProgressView()
		 } else {
			Picker("Select your favorite team", selection: Binding(
			   get: { viewModel.selectedTeam ?? viewModel.teams.first ?? [:] },
			   set: { newValue in
				  viewModel.selectedTeam = newValue
				  if let teamName = newValue["teamName"] {
					 viewModel.fetchSchedule(for: teamName)
				  }
			   }
			)) {
			   ForEach(viewModel.teams, id: \.self) { team in
				  Text(team["teamName"] ?? "")
					 .tag(team)  // Ensure each team has a unique tag
			   }
			}
			.pickerStyle(MenuPickerStyle())
			.padding()

			if let selectedTeam = viewModel.selectedTeam {
			   Text("Games for:")
				  .font(.headline)
				  .padding()
			   Text("\(viewModel.dateRange)")
				  .font(.caption)


			   Text("Upcoming games for \(selectedTeam["teamName"] ?? "")")
				  .font(.headline)
				  .foregroundColor(Color(hex: selectedTeam["teamColor"] ?? "000000"))

			   List(viewModel.schedule, id: \.self) { game in
				  ScheduleRowView(game: game, teamColor: selectedTeam["teamColor"] ?? "000000", teams: viewModel.teams)
					 .listRowBackground(Color.white)
			   }
			} else {
			   Text("Please select a team to view the schedule")
				  .font(.headline)
				  .padding()
			}
		 }
	  }
	  .padding()
	  .background(Color.gray.opacity(0.2)) // Darker background for the main view
	  .navigationTitle("MLB Schedule")
   }
}
