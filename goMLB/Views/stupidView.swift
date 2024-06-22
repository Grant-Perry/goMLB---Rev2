////   stupidView.swift
////   goMLB
////
////   Created by: Grant Perry on 5/3/24 at 12:48 PM
////     Modified: 
////
////  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
////
//
//import SwiftUI
//
//struct PlayerProfileView: View {
//   var playerName: String = "Gerrit Cole"
//   var playerPosition: String = "R/R Pitcher - 2.60 ERA"
//   var playerBio: String = "Gerrit Alan Cole (born September 8, 1990) is an American professional baseball pitcher for the New York Yankees of Major League Baseball (MLB)."
//
//   var body: some View {
//	  ScrollView {
//		 VStack(alignment: .leading, spacing: 20) {
//			header
//			followButton
//			tabView
//			summarySection
//			bioSection
//		 }
//		 .padding()
//	  }
//	  .background(Color.black.edgesIgnoringSafeArea(.all))
//	  .foregroundColor(.white)
//   }
//
//   var header: some View {
//	  VStack {
//		 // Assuming `playerImage` is already defined somewhere as an Image
//		 Image("playerImage")
//			.resizable()
//			.scaledToFit()
//			.frame(width: 150, height: 150)
//			.clipShape(Circle())
//			.overlay(Circle().stroke(Color.gray, lineWidth: 4))
//		 Text(playerName)
//			.font(.title)
//			.bold()
//		 Text(playerPosition)
//			.font(.subheadline)
//	  }
//   }
//
//   var followButton: some View {
//	  Button(action: {
//		 // Action for follow button
//	  }) {
//		 Text("+ Follow")
//			.bold()
//			.frame(width: 120, height: 44)
//			.background(Color.blue)
//			.foregroundColor(.white)
//			.cornerRadius(22)
//	  }
//   }
//
//   var tabView: some View {
//	  TabView {
//		 summarySection
//
//			.tabItem {
//			   Text("Summary")
//			}
//		 Text("Stats Here")
//			.tabItem {
//			   Text("Stats")
//			}
//		 Text("Awards Here")
//			.tabItem {
//			   Text("Awards")
//			}
//	  }
//	  .foregroundColor(.white)
//   }
//
//   var summarySection: some View {
//	  LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: .infinity))], spacing: 20) {
//		 InfoBox(titleTxt: "Height", labelTxt: "6'3\"")
//		 InfoBox(titleTxt: "Weight", labelTxt: "210")
//		 InfoBox(titleTxt: "Age", labelTxt: "33")
//	  }
//   }
//
//
//   var bioSection: some View {
//	  Text(playerBio)
//		 .font(.body)
//		 .padding()
//		 .background(Color.gray.opacity(0.2))
//		 .cornerRadius(12)
//   }
//}
//
//struct InfoBox: View {
//   var titleTxt: String
//   var labelTxt: String
//
//   var body: some View {
//	  VStack {
//		 Text(titleTxt)
//			.font(.caption)
//			.bold()
//		 Text(labelTxt)
//			.font(.title2)
//			.bold()
//	  }
//	  .padding()
//	  .frame(minWidth: 0, maxWidth: .infinity)
//	  .background(Color.gray.opacity(0.25))
//	  .cornerRadius(10)
//   }
//}
////
////@main
////struct PlayerProfileApp: App {
////   var body: some Scene {
////	  WindowGroup {
////		 PlayerProfileView()
////	  }
////   }
////}
//
////
////#Preview {
////    PlayerProfileView()
////}
