//
//  BellyView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI

extension Color {
    static var skin = Color(red: 198/255, green: 134/255, blue: 66/255)
    static var shirt = Color(red: 219/255, green: 83/255, blue: 117/255)
}

struct BellyView: View {
    
    @ObservedObject var viewModel: BellyViewModel
    @State private var scalingFactor: CGFloat = 1
    private let animationDuration: Double = 0.5
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Shirt
            Circle()
                .foregroundColor(.shirt)
            
            // Skin
            Circle()
                .mask(BellyMask().fill(style: FillStyle(eoFill: true)))
                .foregroundColor(.skin)
            
            // Belly button
            Circle()
                .foregroundColor(.black)
                .frame(width: 5, height: 5)
                .padding()
        }
        .scaleEffect(scalingFactor)
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            viewModel.cancellable = viewModel.$isVisible.sink { isVisible in
                isVisible ? appear() : disappear()
            }
        }
    }
    
    private func disappear() {
        // Animation small belly to big belly
        withAnimation(.easeIn(duration: animationDuration)) {
            scalingFactor = 20
        }
    }

    private func appear() {
        // Animation big belly to small belly
        scalingFactor = 20
        withAnimation(.easeOut(duration: animationDuration)) {
            scalingFactor = 1
        }
    }
}

// Animate the edge insets to give illusion of movement
struct BellyMask: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        path.addPath(Circle()
            .path(in: rect
                .inset(by: UIEdgeInsets(top: -100,
                                        left: -100,
                                        bottom: 0,
                                        right: -100))
                    .offsetBy(dx: 0,
                              dy: -50)))
        return path
    }
}

struct BellyView_Previews: PreviewProvider {
    static var previews: some View {
        BellyView(viewModel: BellyViewModel())
            .previewLayout(.sizeThatFits)
    }
}
