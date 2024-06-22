//   Color.swift
//   goMLB
//
//   Created by: Grant Perry on 5/20/24 at 7:13 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

extension Date {
   func deltaStartDays() -> String {
	  let calendar = Calendar.current
	  let now = Date()

	  // Start of the current date
	  let startOfToday = calendar.startOfDay(for: now)

	  // Start of the given date
	  let startOfDate = calendar.startOfDay(for: self)

	  // Calculate the difference in days
	  let components = calendar.dateComponents([.day], from: startOfToday, to: startOfDate)

	  guard let daysDifference = components.day else {
		 return "Invalid date"
	  }

	  switch daysDifference {
		 case 0:
			return "Today"
		 case 1:
			return "Tomorrow"
		 case -1:
			return "Yesterday"
		 default:
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "E" // E stands for the day of the week (e.g., Wed)
			return dateFormatter.string(from: self)
	  }
   }
}
