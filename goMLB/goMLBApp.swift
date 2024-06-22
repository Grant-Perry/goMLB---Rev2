//   goMLBApp.swift
//   goMLB
//
//   Created by: Grant Perry on 4/21/24 at 4:37 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

@main
struct goMLBApp: App {
   var body: some Scene {
	  WindowGroup {
		 TabView {
			ContentView(teamSize: AppConstants.teamSize, teamScoreSize: AppConstants.teamScoreSize)
			   .tabItem {
				  Label("Games", systemImage: "figure.baseball")
			   }

			ScheduleView()
			   .tabItem {
				  Label("Schedule", systemImage: "calendar")
			   }
		 }
	  }
   }
}



