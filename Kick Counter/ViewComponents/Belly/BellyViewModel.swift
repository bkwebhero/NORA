//
//  BellyViewModel.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import Foundation
import Combine

class BellyViewModel: ObservableObject {
    var isBigCancellable: AnyCancellable?
    @Published var isBig: Bool = false
    var kickCancellable: AnyCancellable?
    @Published var kick: Bool = false
}
