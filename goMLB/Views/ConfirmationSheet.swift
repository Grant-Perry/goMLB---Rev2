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
	  VStack(alignment: .center) {
		 if let selectedTeam = selectedTeam {
			VStack(alignment: .center, spacing: 0) {
			   Text("You're changing \nyour favorite team from \n")
				  .font(.system(size: 14))
				  .padding(.top, -3)
				  .multilineTextAlignment(.center) // Center the text
			   Text("\(gameViewModel.favTeam)")
				  .font(.system(size: 25, weight: .bold))
				  .multilineTextAlignment(.center) // Center the text
			   Text("to:")
				  .font(.system(size: 14))
				  .padding(.top, -4)
				  .padding(.bottom, 3) // Add some spacing before 'New Team Name'
				  .multilineTextAlignment(.center) // Center the text
			   Text(selectedTeam)
				  .font(.system(size: 25, weight: .bold))
				  .padding(.top, -5)
				  .multilineTextAlignment(.center) // Center the text
			   Text("Are you sure?")
				  .font(.system(size: 14))
				  .padding(.top, 10) // Add spacing above "Are you sure?"
				  .multilineTextAlignment(.center) // Center the text
			}
			.padding() // Add padding around the entire VStack

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
	  .frame(width: 250, height: 250, alignment: .center)
	  .background(Color.blue.gradient)
	  .cornerRadius(15)
	  .background(BackgroundClearView())
   }
}
