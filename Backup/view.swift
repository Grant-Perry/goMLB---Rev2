//   view.swift
//   goMLB
//
//   Created by: Grant Perry on 5/22/24 at 11:25 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

extension View {
   // unit is color
   
   func horizontallyCentered() -> some View {
	  HStack {
		 Spacer(minLength: 0)
		 self
		 Spacer(minLength: 0)
	  }
   }

   func leftJustify() -> some View {
	  HStack {
		 self
		 Spacer(minLength: 0)
	  }
   }

   func rightJustify() -> some View {
	  HStack {
		 Spacer(minLength: 10)
		 self
	  }
   }
}
