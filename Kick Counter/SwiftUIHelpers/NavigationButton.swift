//
//  NavigationButton.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import Foundation
import SwiftUI

struct NavigationButton<Destination: View, Label: View>: View {
    var action: () -> Void = { }
    var destination: () -> Destination
    var label: () -> Label
    
    @State private var isActive: Bool = false
    
    var body: some View {
        Button(action: {
            self.action()
            self.isActive.toggle()
        }) {
            self.label()
                .background(
                    ScrollView {
                        NavigationLink(destination: LazyDestination { self.destination() },
                                       isActive: self.$isActive) { EmptyView() }
                    }
                )
        }
    }
}

// This view lets us avoid instantiating our Destination before it has been pushed.
struct LazyDestination<Destination: View>: View {
    var destination: () -> Destination
    var body: some View {
        self.destination()
    }
}
