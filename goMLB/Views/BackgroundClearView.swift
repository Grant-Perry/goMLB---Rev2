//   BackgroundClearView.swift
//   goMLB
//
//   Created by: Grant Perry on 6/14/24 at 11:16 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct BackgroundClearView: UIViewRepresentable {
   func makeUIView(context: Context) -> UIView {
	  let view = UIView()
	  DispatchQueue.main.async {
		 view.superview?.superview?.backgroundColor = UIColor.clear
	  }
	  return view
   }
   func updateUIView(_ uiView: UIView, context: Context) {}
}
