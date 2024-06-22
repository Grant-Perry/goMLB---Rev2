//   GameSchedule.swift
//   goMLB
//
//   Created by: Grant Perry on 6/22/24 at 11:53 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct GameSchedule: Identifiable {
   let id = UUID()
   let date: String
   let time: String
   let matchup: String
   let location: String
   let result: String?
}
