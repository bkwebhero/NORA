//
//  HistoryView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: Environment
    /// Used to go back when tapping Cancel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: HistoryViewModel
    /// Size of circle for fade in/out animation
    @State var circleScale = 10.0
    
    var body: some View {
        VStack {
            // MARK: Cancel button
            // Ideally this would be in navigation bar but SwiftUI does not yet offer enough control over animations
            // I want animation after tapping back button but before navigating back
            // Not an option with navigation bar at the moment
            HStack {
                Button(action: {
                    withAnimation {
                        circleScale = 20
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss()
                    }
                }){
                    Text("Cancel")
                        .font(Font.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }
            
            ZStack {
                List {
                    ForEach(viewModel.sessions, id: \.self) { session in
                        HistoryRowView(viewModel: createHistoryRowViewModel(for: session))
                            .padding([.top, .bottom])
                    }
                    .onDelete { indices in
                        viewModel.delete(at: indices)
                    }
                }
                
                // Fade in/out animation
                Circle()
                    .scaleEffect(circleScale)
                    .foregroundColor(.shirt)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                circleScale = 0
            }
        }
    }
    
    private func createHistoryRowViewModel(for session: Session) -> HistoryRowViewModel {
        return HistoryRowViewModel(session: session)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: HistoryViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
