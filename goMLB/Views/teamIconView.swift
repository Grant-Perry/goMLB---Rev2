//   teamIconView.swift
//   goMLB
//
//   Created by: Gp. on 4/25/24 at 10:30 AM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct TeamIconView: View {
   var teamName: String
   var teamLogo: String

   var body: some View {
	  VStack {
		 if !teamLogo.isEmpty {
			Image(uiImage: loadImage(from: teamLogo))
			   .resizable()
			   .frame(width: 100, height: 100)
			   .clipShape(Circle())
			   .overlay(Circle().stroke(Color.white, lineWidth: 4))
			   .shadow(radius: 10)
			   .padding()
		 } else {
			Image(systemName: "photo")
			   .resizable()
			   .frame(width: 100, height: 100)
			   .clipShape(Circle())
			   .overlay(Circle().stroke(Color.white, lineWidth: 4))
			   .shadow(radius: 10)
			   .padding()
		 }

		 Text(teamName)
			.font(.title)
			.bold()
			.padding()
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

struct TeamIconView_Previews: PreviewProvider {
   static var previews: some View {
	  TeamIconView(
		 teamName: "Yankees",
		 teamLogo: "https://example.com/yankees.png"
	  )
   }
}
