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
    
    var body: some View {
        VStack(spacing: 8) {

            // Timer text
            Text(viewModel.timeStarted, style: .relative)
                .font(Font.system(size: 20, weight: .medium))
                .padding(.top, 32)
            Spacer()
            
            // Belly view
            Button {
                viewModel.kick()
                withAnimation(.linear(duration: 0.1)) {
                    scalingFactor = 1.5
                }
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            } label: {
                BellyView()
                    .padding()
                    .modifier(ReversingScale(to: scalingFactor, onEnded: {
                        DispatchQueue.main.async {
                            withAnimation(.easeOut(duration: 0.25)) {
                                scalingFactor = 1.0
                            }
                        }
                    }))
            }
            .buttonStyle(StaticButtonStyle())
            
            Spacer()
            
            // Progress text
            Text(viewModel.progressText)
                .font(Font.system(size: 20, weight: .medium))
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            withAnimation(.easeIn(duration: animationDuration)) {
                scalingFactor = 20
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                viewModel.cancel()
            }
        }){
            Text("Cancel")
                .font(Font.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
        })
        .onAppear {
            // Animation big belly to small belly
            scalingFactor = 20
            withAnimation(.easeOut(duration: animationDuration)) {
                scalingFactor = 1
            }
            
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
        CounterView(viewModel: CounterViewModel(viewContext: PersistenceController.preview.container.viewContext)).previewDevice("iPhone 11")
    }
}
