//   PitcherDetailsView.swift
//   goMLB
//
//   Created by: Grant Perry on 6/14/24 at 7:01 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

// PitcherDetailsView.swift
import SwiftUI

struct PitcherDetailsView: View {
   var pitcherName: String
   var pitcherPic: String
   var pitcherERA: String
   var pitcherWins: Int
   var pitcherLosses: Int
   var pitcherStrikeOuts: Int
   var pitcherThrows: String

   var body: some View {
	  VStack {
		 Text(pitcherName)
			.font(.largeTitle)
			.bold()
			.padding()

		 if !pitcherPic.isEmpty {
			Image(uiImage: loadImage(from: pitcherPic))
			   .resizable()
			   .frame(width: 100, height: 100)
			   .clipShape(Circle())
			   .overlay(Circle().stroke(Color.white, lineWidth: 4))
			   .shadow(radius: 10)
			   .padding()
		 }

		 VStack(alignment: .leading) {
			Text("ERA: \(pitcherERA)")
			Text("Wins: \(pitcherWins)")
			Text("Losses: \(pitcherLosses)")
			Text("Strike Outs: \(pitcherStrikeOuts)")
			Text("Throws: \(pitcherThrows)")
		 }
		 .font(.title2)
		 .padding()

		 Spacer()
	  }
	  .background(Color(.systemBackground))
	  .cornerRadius(10)
	  .shadow(radius: 5)
	  .padding()
   }

   private func loadImage(from urlString: String) -> UIImage {
	  guard let url = URL(string: urlString),
			let data = try? Data(contentsOf: url),
			let image = UIImage(data: data) else {
		 return UIImage(systemName: "photo") ?? UIImage()
	  }
	  return image
   }
}

struct PitcherDetailsView_Previews: PreviewProvider {
   static var previews: some View {
	  PitcherDetailsView(
		 pitcherName: "Gerrit Cole",
		 pitcherPic: "https://example.com/gerritcole.png",
		 pitcherERA: "2.50",
		 pitcherWins: 5,
		 pitcherLosses: 2,
		 pitcherStrikeOuts: 55,
		 pitcherThrows: "Right"
	  )
   }
}
