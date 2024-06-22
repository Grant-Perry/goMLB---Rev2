////   CalendarView.swift
////   goMLB
////
////   Created by: Grant Perry on 6/22/24 at 12:00 PM
////     Modified: 
////
////  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
////
//
//import SwiftUI
//
//struct CalendarViewssssss: View {
//   let gameSchedules: [GameSchedule]
//
//   var body: some View {
//	  ScrollView {
//		 VStack {
//			ForEach(getUniqueDates(), id: \.self) { date in
//			   VStack(alignment: .leading) {
//				  Text(date)
//					 .font(.headline)
//				  ForEach(gameSchedules.filter { $0.date == date }) { schedule in
//					 HStack {
//						Text(schedule.matchup)
//						Spacer()
//						Text(schedule.time)
//					 }
//					 .padding(.leading, 10)
//					 .padding(.trailing, 10)
//				  }
//			   }
//			   .padding()
//			}
//		 }
//	  }
//   }
//   
//   private func getUniqueDates() -> [String] {
//	  let dates = gameSchedules.map { $0.date }
//	  return Array(Set(dates)).sorted()
//   }
//}
//
