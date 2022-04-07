//
//  BellyViewModel.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import Foundation
import Combine

class BellyViewModel: ObservableObject {
    var cancellable: AnyCancellable?
    @Published var isVisible: Bool = false
}
