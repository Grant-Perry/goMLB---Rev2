//   scoreCardView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/10/24 at 1:24 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct scoreCardView: View {
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

   let home: String?
   let homeScore: String
   let homeRecord: String?
   let visitorRecord: String?
   let homeColor: String?
   let visitors: String?
   let visitScore: String
   let visitColor: String?
   let homeWin: Bool
   let visitWin: Bool
   let inningTxt: String?
   let startTime: String?
   let atBat: String?
   let atBatPic: String?
   let batterStats: String?
   let batterLine: String?
   var winColor: Color { .green }
   var thisIsInProgress: Bool { event.isInProgress }

   init(vm: GameViewModel, titleSize: CGFloat, showModal: Binding<Bool>, tooDark: String, event: gameEvent, scoreSize: Int, numUpdates: Binding<Int>, refreshGame: Binding<Bool>, timeRemaining: Binding<Int>, selectedEventID: Binding<String?>) {
	  self.vm = vm
	  self.titleSize = titleSize
	  self.tooDark = tooDark
	  self.event = event
	  self.scoreSize = scoreSize
	  self._numUpdates = numUpdates
	  self._refreshGame = refreshGame
	  self._timeRemaining = timeRemaining
	  self._selectedEventID = selectedEventID
	  self._showModal = showModal

	  self.home = vm.filteredEvents.first?.home
	  self.homeScore = vm.filteredEvents.first?.homeScore ?? "0"
	  self.homeRecord = vm.filteredEvents.first?.homeRecord
	  self.visitorRecord = vm.filteredEvents.first?.visitorRecord
	  self.homeColor = vm.filteredEvents.first?.homeColor
	  self.visitors = vm.filteredEvents.first?.visitors
	  self.visitScore = vm.filteredEvents.first?.visitScore ?? "0"
	  self.visitColor = vm.filteredEvents.first?.visitorAltColor
	  self.inningTxt = vm.filteredEvents.first?.inningTxt
	  self.atBat = vm.filteredEvents.first?.atBat
	  self.atBatPic = vm.filteredEvents.first?.atBatPic
	  self.batterStats = vm.filteredEvents.first?.batterStats
	  self.batterLine = vm.filteredEvents.first?.batterLine

	  self.startTime = event.startTime

	  self.homeWin = (Int(visitScore) ?? 0) < (Int(homeScore) ?? 0)
	  self.visitWin = (Int(visitScore) ?? 0) > (Int(homeScore) ?? 0)
   }

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
						Text("\(visitors ?? "")")
					 }
					 .font(.title3)
					 .minimumScaleFactor(0.5)
					 .lineLimit(1)
					 .frame(maxWidth: .infinity, alignment: .trailing)
					 .foregroundColor(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark))

					 Text("\(visitorRecord ?? "")")
						.font(.caption)
						.padding(.trailing, 5)
						.foregroundColor(.gray)
						.frame(maxWidth: .infinity, alignment: .trailing)

					 HStack {
						TeamIconView(team: APIResponse.Event.Competition.Competitor.Team(
						   name: "Visitor",
						   color: visitColor,
						   alternateColor: nil,
						   logo: nil,
						   logos: [
							  APIResponse.Event.Competition.Competitor.Team.Logo(
								 href: event.visitorLogo,
								 width: nil,
								 height: nil
							  )
						   ]
						))
						.clipShape(Circle())
					 }
					 .frame(maxWidth: .infinity, alignment: .center)
					 .padding(.bottom, 2)
				  }
			   }
			   Text("\(visitScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .bold()
				  .padding(.trailing)
				  .foregroundColor(visitWin && Int(visitScore) ?? 0 > 0 ? winColor : Color(getColorForUI(hex: visitColor ?? "#000000", thresholdHex: tooDark)))
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			.background(
			   Group {
				  if visitWin, Int(visitScore) ?? 0 > 0 {
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
			   if inningTxt?.contains("Bottom") ?? false {
				  Image(systemName: "arrowtriangle.right.fill")
					 .imageScale(.small)
			   } else if inningTxt?.contains("Top") ?? false {
				  Image(systemName: "arrowtriangle.left.fill")
			   }
			   Text("\(homeScore)")
				  .font(.system(size: CGFloat(scoreSize)))
				  .bold()
				  .padding(.leading)
				  .foregroundColor(homeWin && Int(homeScore) ?? 0 > 0 ? winColor : Color(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark)))

			   VStack(alignment: .leading) {
				  VStack {
					 Text("\(home ?? "")")
						.font(.title3)
						.foregroundColor(getColorForUI(hex: homeColor ?? "#000000", thresholdHex: tooDark))
						.minimumScaleFactor(0.5)
						.frame(maxWidth: .infinity, alignment: .leading)
						.lineLimit(1)

					 Text("\(vm.filteredEvents.first?.homeRecord ?? "")")
						.font(.caption)
						.foregroundColor(.gray)
						.frame(maxWidth: .infinity, alignment: .leading)

					 HStack {
						TeamIconView(team: APIResponse.Event.Competition.Competitor.Team(
						   name: "Home",
						   color: homeColor,
						   alternateColor: nil,
						   logo: nil,
						   logos: [
							  APIResponse.Event.Competition.Competitor.Team.Logo(
								 href: event.homeLogo,
								 width: nil,
								 height: nil
							  )
						   ]
						))
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
				  if homeWin, Int(homeScore) ?? 0 > 0 {
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

		 if let atBat = atBat, !atBat.isEmpty {
			VStack {
			   Text("At Bat: \(atBat)")
				  .font(.headline)
				  .onTapGesture {
					 if let url = URL(string: event.batterBioURL) {
						UIApplication.shared.open(url)
					 }
				  }
			   if let batterStats = batterStats {
				  Text("Avg: \(batterStats)  |  \(batterLine ?? "")")
					 .font(.subheadline)
			   }
			   Spacer()
			   VStack {
				  AsyncImage(url: URL(string: atBatPic ?? "")) { phase in
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
						   if let url = URL(string: event.homePitcherBioURL) {
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

					 AsyncImage(url: URL(string: event.currentPitcherPic ?? "")) { phase in
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
									if let url = URL(string: event.homePitcherBioURL) {
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
