//
//  CounterView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI
import CoreData

struct CounterView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CounterViewModel
    @State private var scalingFactor: CGFloat = 1
    private let animationDuration: Double = 0.5
    @State var bellyViewModel: BellyViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            
            // Cancel button
            // Ideally this would be in navigation bar but SwiftUI does not yet offer enough control over animations
            // I want the belly to expand and hide the cancel button
            // Not an option with navigation bar at the moment
            HStack {
                Button(action: {
                    bellyViewModel.isVisible = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        viewModel.cancel()
                    }
                }){
                    Text("Cancel")
                        .font(Font.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }
            
            // Timer text
            Text(viewModel.timeStarted, style: .relative)
                .font(Font.system(size: 20, weight: .medium))
                .padding(.top, 32)
            Spacer()
            
            // Belly view
            Button {
                // Increment progress towards goal of 10 kicks
                viewModel.kick()
                // Make belly view expand and shrink back down
                withAnimation(.linear(duration: 0.1)) {
                    scalingFactor = 1.5
                }
                // Haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            } label: {
                BellyView(viewModel: bellyViewModel)
                    .padding()
                    // Custom modifier to reverse the kick animation once it is at full size
                    .modifier(ReversingScale(to: scalingFactor, onEnded: {
                        DispatchQueue.main.async {
                            withAnimation(.easeOut(duration: 0.25)) {
                                scalingFactor = 1.0
                            }
                        }
                    }))
            }
            // Make sure belly hides all text when fully expanded for animation
            .zIndex(5)
            .buttonStyle(StaticButtonStyle())
            
            Spacer()
            
            // Progress text
            Text(viewModel.progressText)
                .font(Font.system(size: 20, weight: .medium))
                .zIndex(1)
            
            Spacer()
            
        }
        .navigationBarHidden(true)
        .onAppear {
            bellyViewModel.isVisible = true
            viewModel.cancellable = viewModel.$goalMet.sink { goalMet in
                if goalMet {
                    dismiss()
                }
            }
        }
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(viewModel: CounterViewModel(viewContext: PersistenceController.preview.container.viewContext), bellyViewModel: BellyViewModel()).previewDevice("iPhone 11")
    }
}
