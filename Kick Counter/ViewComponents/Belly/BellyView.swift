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
    
    static let animationDuration: Double = 0.5
    
    // Informs when to grow/shrink
    @State var viewModel: BellyViewModel
    @State private var scalingFactor: CGFloat = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Shirt
            Circle()
                .foregroundColor(.shirt)
            
            // Skin
            Circle()
                .mask(BellyMask().fill(style: fillStyle))
                .foregroundColor(.skin)
            
            // Belly button
            Circle()
                .foregroundColor(.black)
                .frame(width: 5, height: 5)
                .padding()
        }
        .scaleEffect(scalingFactor)
        .aspectRatio(1, contentMode: .fit)
        // Custom modifier to reverse the kick animation once it is at full size
        .modifier(ReversingScale(to: scalingFactor, onEnded: {
            stopKick()
        }))
        .onAppear {
            viewModel.isBigCancellable = viewModel.$isBig.sink { isBig in
                isBig ? grow() : shrink()
            }
            viewModel.kickCancellable =  viewModel.$kick.sink { shouldKick in
                guard shouldKick else { return }
                kick()
            }
        }
    }
    
    private var fillStyle: FillStyle {
        return FillStyle(eoFill: true)
    }
    
    private func kick() {
        withAnimation(.easeIn(duration: 0.1)) {
            scalingFactor = 1.1
        }
        viewModel.kick = false
    }
    
    private func stopKick() {
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.25)) {
                scalingFactor = 1.0
            }
        }
    }
    
    private func shrink() {
        withAnimation(.easeIn(duration: BellyView.animationDuration)) {
            scalingFactor = 20
        }
    }

    private func grow() {
        scalingFactor = 20
        withAnimation(.easeOut(duration: BellyView.animationDuration)) {
            scalingFactor = 1
        }
    }
}

struct BellyView_Previews: PreviewProvider {
    static var previews: some View {
        BellyView(viewModel: BellyViewModel())
            .previewLayout(.sizeThatFits)
    }
}
