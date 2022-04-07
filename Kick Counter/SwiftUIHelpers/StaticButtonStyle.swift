//
//  StaticButtonStyle.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import SwiftUI

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
