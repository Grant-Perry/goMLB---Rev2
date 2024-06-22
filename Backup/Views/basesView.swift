//   basesView.swift
//   goMLB
//
//   Created by: Grant Perry on 4/22/24 at 3:00 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct BasesView: View {
   var onFirst: Bool
   var onSecond: Bool
   var onThird: Bool

   var body: some View {
	  VStack {
		 Text("Bases")
			.font(.title)
			.padding()

		 HStack {
			Circle()
			   .fill(onFirst ? Color.green : Color.gray)
			   .frame(width: 50, height: 50)
			   .overlay(Text("1").foregroundColor(.white))
			Circle()
			   .fill(onSecond ? Color.green : Color.gray)
			   .frame(width: 50, height: 50)
			   .overlay(Text("2").foregroundColor(.white))
			Circle()
			   .fill(onThird ? Color.green : Color.gray)
			   .frame(width: 50, height: 50)
			   .overlay(Text("3").foregroundColor(.white))
		 }
		 .padding()
	  }
	  .background(Color(.systemBackground))
	  .cornerRadius(10)
	  .shadow(radius: 5)
	  .padding()
   }
}

struct BasesView_Previews: PreviewProvider {
   static var previews: some View {
	  BasesView(onFirst: true, onSecond: false, onThird: true)
   }
}
