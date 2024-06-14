//   ConfirmationSheet.swift
//   goMLB
//
//   Created by: Grant Perry on 6/14/24 at 11:10 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct ConfirmationSheet: View {
   @Binding var selectedTeam: String?
   @ObservedObject var gameViewModel: GameViewModel
   @Environment(\.presentationMode) var presentationMode

   var body: some View {
	  VStack {
		 if let selectedTeam = selectedTeam {
			Text("You're changing your Favorite Team from\n\(gameViewModel.favTeam) to \(selectedTeam). \nAre you sure?")
			   .font(.headline)
			   .padding()
			HStack {
			   Button(action: {
				  gameViewModel.setFavoriteTeam(teamName: selectedTeam)
				  self.selectedTeam = nil // Reset selectedTeam after confirmation or denial
				  presentationMode.wrappedValue.dismiss()
			   }) {
				  Text("Yes")
					 .padding()
					 .background(.green.gradient)
					 .foregroundColor(.white)
					 .cornerRadius(10)
			   }
			   Button(action: {
				  self.selectedTeam = nil // Reset selectedTeam after confirmation or denial
				  presentationMode.wrappedValue.dismiss()
			   }) {
				  Text("No")
					 .padding()
					 .background(.yellow.gradient)
					 .foregroundColor(.white)
					 .cornerRadius(10)
			   }
			}
		 }
	  }
	  .frame(width: 250, height: 250)
	  .background(Color.blue.gradient)
	  .cornerRadius(15)
	  .background(BackgroundClearView())
   }
}
