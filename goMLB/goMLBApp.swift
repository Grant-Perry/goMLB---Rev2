//   goMLBApp.swift
//   goMLB
//
//   Created by: Grant Perry on 4/21/24 at 4:37 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

// Main App
@main
struct goMLBApp: App {
   var body: some Scene {
	  WindowGroup {
		 MainTabView()
	  }
   }
}

struct MainTabView: View {
   var body: some View {
	  TabView {
		 ContentView(teamSize: AppConstants.teamSize, teamScoreSize: AppConstants.teamScoreSize)
			.tabItem {
			   Label("Home", systemImage: "house")
			}

		 ScheduleView()
			.tabItem {
			   Label("Schedule", systemImage: "calendar")
			}
	  }
   }
}

// Preview Provider
struct goMLBApp_Previews: PreviewProvider {
   static var previews: some View {
	  MainTabView()
		 .preferredColorScheme(.dark)
   }
}
