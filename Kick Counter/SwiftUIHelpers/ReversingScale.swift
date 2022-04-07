//
//  ReversingScale.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import SwiftUI

struct ReversingScale: AnimatableModifier {
    var value: CGFloat

    private var target: CGFloat
    private var onEnded: () -> ()

    init(to value: CGFloat, onEnded: @escaping () -> () = {}) {
        self.target = value
        self.value = value
        self.onEnded = onEnded
    }

    var animatableData: CGFloat {
        get { value }
        set { value = newValue
            if newValue == target {
                onEnded()
            }
        }
    }

    func body(content: Content) -> some View {
        content.scaleEffect(value)
    }
}
