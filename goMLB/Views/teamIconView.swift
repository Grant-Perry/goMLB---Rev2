import SwiftUI

struct TeamIconView: View {
   var team: [String: Any]

   var body: some View {
	  let teamColor = (team["color"] as? String) ?? "#000000" // Default to black if color is not provided
	  let teamIcon = getPreferredLogo(for: team)

	  ZStack {
		 Circle()
			.fill(Color(hex: teamColor))
			.frame(width: 50, height: 50)

		 if let url = URL(string: teamIcon) {
			AsyncImage(url: url) { phase in
			   switch phase {
				  case .empty:
					 ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.frame(width: 50, height: 50)
				  case .success(let image):
					 image.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
						.clipShape(Circle())
				  case .failure:
					 Image(systemName: "exclamationmark.triangle.fill") // Example error image
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
						.foregroundColor(.red)
						.clipShape(Circle())
				  @unknown default:
					 EmptyView()
			   }
			}
		 } else {
			Image(systemName: "photo")
			   .resizable()
			   .scaledToFit()
			   .frame(width: 50, height: 50)
			   .foregroundColor(.gray)
			   .clipShape(Circle())
		 }
	  }
   }

   // Function to get the preferred logo
   func getPreferredLogo(for team: [String: Any]) -> String {
	  guard let logos = team["logos"] as? [[String: Any]], let secondLogo = logos.indices.contains(1) ? logos[1] : nil else {
		 return (team["logo"] as? String) ?? ""
	  }
	  return (secondLogo["href"] as? String) ?? ""
   }
}

