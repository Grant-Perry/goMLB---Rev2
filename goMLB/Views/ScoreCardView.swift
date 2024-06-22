//   scoreCardView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/10/24 at 1:24 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct ScoreCardView: View {
   @ObservedObject var vm: GameViewModel
   @Binding var selectedEventID: String?
   @Binding var showModal: Bool

   var titleSize: CGFloat
   var tooDark: String
   var event: gameEvent
   var scoreSize: Int
   @Binding var numUpdates: Int
   @Binding var refreshGame: Bool
   @Binding var timeRemaining: Int

   var winColor: Color { .green }
   var thisIsInProgress: Bool { event.isInProgress }

   var body: some View {
	  VStack {
		 VStack {
			HeaderView(
			   gameViewModel: vm,
			   showModal: $showModal,
			   selectedEventID: $selectedEventID,
			   event: event,
			   visitors: event.visitors,
			   home: event.home,
			   visitColor: event.visitorColor,
			   homeColor: event.homeColor,
			   inningTxt: event.inningTxt,
			   startTime: event.startTime,
			   tooDark: tooDark,
			   isToday: vm.isToday,
			   eventOuts: event.outs,
			   refreshGame: $refreshGame,
			   numUpdates: $numUpdates,
			   timeRemaining: $timeRemaining,
			   thisIsInProgress: thisIsInProgress
			)
		 }

		 HStack(spacing: 0) {
			HStack {
			   VStack(alignment: .leading, spacing: 0) {
				  VStack {
					 HStack {
						Text("\(event.visitors)")
					 }
					 .font(.title3)
					 .minimumScaleFactor(0.5)
					 .lineLimit(1)
					 .frame(maxWidth: .infinity, alignment: .trailing)
					 .foregroundColor(getColorForUI(hex: event.visitorColor, thresholdHex: tooDark))

					 Text("\(event.visitorRecord)")
						.font(.caption)
						.padding(.trailing, 5)
						.foregroundColor(.gray)
						.frame(maxWidth: .infinity, alignment: .trailing)

					 HStack {
						TeamIconView(team: [
						   "name": event.visitors,
						   "color": event.visitorColor,
						   "logo": event.visitorLogo
						])
						.clipShape(Circle())
					 }
					 .frame(maxWidth: .infinity, alignment: .center)
					 .padding(.bottom, 2)
				  }
			   }
			   Text("\(event.visitScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .bold()
				  .padding(.trailing)
				  .foregroundColor(event.visitorWin ? winColor : getColorForUI(hex: event.visitorColor, thresholdHex: tooDark))
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			.background(
			   Group {
				  if event.visitorWin {
					 LinearGradient(
						gradient: Gradient(colors: [Color.clear, Color.green.opacity(0.5)]),
						startPoint: .trailing,
						endPoint: .leading
					 )
				  } else {
					 Color.clear
				  }
			   }
			)

			HStack {
			   if event.inningTxt.contains("Bottom") {
				  Image(systemName: "arrowtriangle.right.fill")
					 .imageScale(.small)
			   } else if event.inningTxt.contains("Top") {
				  Image(systemName: "arrowtriangle.left.fill")
			   }
			   Text("\(event.homeScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .bold()
				  .padding(.leading)
				  .foregroundColor(event.homeWin ? winColor : getColorForUI(hex: event.homeColor, thresholdHex: tooDark))

			   VStack(alignment: .leading) {
				  VStack {
					 Text("\(event.home)")
						.font(.title3)
						.foregroundColor(getColorForUI(hex: event.homeColor, thresholdHex: tooDark))
						.minimumScaleFactor(0.5)
						.frame(maxWidth: .infinity, alignment: .leading)
						.lineLimit(1)

					 Text("\(event.homeRecord)")
						.font(.caption)
						.foregroundColor(.gray)
						.frame(maxWidth: .infinity, alignment: .leading)

					 HStack {
						TeamIconView(team: [
						   "name": event.home,
						   "color": event.homeColor,
						   "logo": event.homeLogo
						])
						.clipShape(Circle())
					 }
					 .frame(maxWidth: .infinity, alignment: .center)
					 .padding(.bottom, 2)
				  }
			   }
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(
			   Group {
				  if event.homeWin {
					 LinearGradient(
						gradient: Gradient(colors: [Color.clear, Color.green.opacity(0.5)]),
						startPoint: .leading,
						endPoint: .trailing
					 )
				  } else {
					 Color.clear
				  }
			   }
			)
		 }

		 if event.atBat != "N/A" {
			VStack {
			   Text("At Bat: \(event.atBat)")
				  .font(.headline)
				  .onTapGesture {
					 if let url = URL(string: event.batterBioURL) {
						UIApplication.shared.open(url)
					 }
				  }
			   if !event.batterStats.isEmpty {
				  Text("Avg: \(event.batterStats)  |  \(event.batterLine)")
					 .font(.subheadline)
			   }
			   Spacer()
			   VStack {
				  AsyncImage(url: URL(string: event.atBatPic)) { phase in
					 switch phase {
						case .empty:
						   ProgressView()
							  .progressViewStyle(CircularProgressViewStyle())
							  .frame(width: 140, height: 140)
						case .success(let image):
						   image.resizable()
							  .scaledToFit()
							  .frame(width: 140, height: 140)
							  .clipShape(Circle())
							  .onTapGesture {
								 if let url = URL(string: event.batterBioURL) {
									UIApplication.shared.open(url)
								 }
							  }
						case .failure:
						   Image(systemName: "photo")
							  .resizable()
							  .scaledToFit()
							  .frame(width: 140, height: 140)
							  .foregroundColor(.gray)
							  .clipShape(Circle())
						@unknown default:
						   EmptyView()
					 }
				  }

				  VStack {
					 Text(event.currentPitcherName)
						.font(.subheadline)
						.onTapGesture {
						   if let url = URL(string: event.currentPitcherBioURL) {
							  UIApplication.shared.open(url)
						   }
						}
					 VStack(alignment: .leading) {
						Text("ERA: \(event.currentPitcherERA)")
						Text("Pitches: \(event.currentPitcherPitchesThrown)")
						if let speed = event.currentPitcherLastPitchSpeed {
						   Text("Speed: \(speed)")
						}
						if let type = event.currentPitcherLastPitchType {
						   Text("Type: \(type)")
						}
					 }
					 .font(.footnote)
					 .foregroundColor(.white)

					 AsyncImage(url: URL(string: event.currentPitcherPic)) { phase in
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
								 .onTapGesture {
									if let url = URL(string: event.currentPitcherBioURL) {
									   UIApplication.shared.open(url)
									}
								 }
						   case .failure:
							  Image(systemName: "photo")
								 .resizable()
								 .scaledToFit()
								 .frame(width: 50, height: 50)
								 .foregroundColor(.gray)
								 .clipShape(Circle())
						   @unknown default:
							  EmptyView()
						}
					 }
				  }
			   }
			   .padding()
			   .foregroundColor(.white)
			}
		 }
	  }
	  .frame(width: UIScreen.main.bounds.width * 0.9)
	  .padding(.bottom, 50)
   }
}

private func hexToInt(_ hex: String) -> Int {
   var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
   if hexSanitized.hasPrefix("#") {
	  hexSanitized.remove(at: hexSanitized.startIndex)
   }
   var intValue: UInt64 = 0
   Scanner(string: hexSanitized).scanHexInt64(&intValue)
   return Int(intValue)
}

