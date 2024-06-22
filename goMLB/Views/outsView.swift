//   outsView.swift
//   goMLB
//
//   Created by: Grant Perry on 4/27/24 at 4:42 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

// outsView.swift
import SwiftUI

struct outsView: View {
   @Environment(\.colorScheme) var colorScheme

   let outs: Int
   var iconDark: String {
	  colorScheme == .dark ? "circle.fill" : "circle.fill"
   }
   var iconLight: String {
	  colorScheme == .dark ? "circle" : "circle"
   }

   var body: some View {
	  HStack(spacing: 2) {
		 Image(systemName: outs >= 1 ? iconDark : iconLight)
		 Image(systemName: outs >= 2 ? iconDark : iconLight)
	  }
   }
}

#Preview {
   outsView(outs: 2)
}
