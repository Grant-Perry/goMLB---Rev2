//   timerRemaingView.swift
//   goMLB
//
//   Created by: Grant Perry on 5/8/24 at 5:29 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct timerRemaingView: View {
   @Binding var timeRemaining: Int  // Accept a binding to an external state

   var body: some View {
	  Text("\(timeRemaining)")
//		 .font(.body)
		 .foregroundColor(.white)
//		 .padding()
   }
}


