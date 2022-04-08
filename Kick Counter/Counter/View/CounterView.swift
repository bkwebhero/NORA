//
//  CounterView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI
import CoreData

struct CounterView: View {
    
    // MARK: Environment
    /// Used to go back when tapping Cancel or reaching goal
    @Environment(\.dismiss) var dismiss
    
    // MARK: View models
    /// Tracks progress
    /// Stores/updates text
    /// Saves/deletes data
    @ObservedObject var viewModel: CounterViewModel
    /// Tells BellyView when and how to animate
    @ObservedObject var bellyViewModel: BellyViewModel
    /// Have cancel button slide down on appear
    @State var cancelButtonOffset: CGFloat = -100
    
    // MARK: State
    /// Used for kick animation
    @State private var scalingFactor: CGFloat = 1
    
    var body: some View {
        VStack(spacing: 8) {
            
            // MARK: Cancel button
            // Ideally this would be in navigation bar but SwiftUI does not yet offer enough control over animations
            // I want the belly to expand and hide the cancel button
            // Not an option with navigation bar at the moment
            HStack {
                Button(action: {
                    bellyViewModel.isBig = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + BellyView.animationDuration) {
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
            .offset(x: 0, y: cancelButtonOffset)
            
            // MARK: Timer text
            Text(viewModel.timeStarted, style: .relative)
                .font(Font.system(size: 24, weight: .bold))
                .padding(.top, 32)
            Spacer()
            
            // MARK: Belly view
            Button {
                // Increment progress towards goal of 10 kicks
                
                viewModel.kick()
                if !viewModel.lastKick {
                    bellyViewModel.kick = true
                }
                // Haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            } label: {
                BellyView(viewModel: bellyViewModel)
                    .padding()
            }
            // Make sure belly hides all text when fully expanded for animation
            .zIndex(5)
            // Don't show button highlighting
            .buttonStyle(StaticButtonStyle())

            Spacer()
            
            // MARK: Progress text
            Text(viewModel.progressText)
                .font(Font.system(size: 24, weight: .bold))
                .zIndex(1)
            
            Spacer()
            
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.linear(duration: BellyView.animationDuration)) {
                cancelButtonOffset = 0
            }
            bellyViewModel.isBig = true
            // Listen for goal met event
            viewModel.cancellable = viewModel.$goalMet.sink { goalMet in
                if goalMet {
                    bellyViewModel.isBig = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + BellyView.animationDuration) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(viewModel: CounterViewModel(viewContext: PersistenceController.preview.container.viewContext), bellyViewModel: BellyViewModel()).previewDevice("iPhone 11")
    }
}
