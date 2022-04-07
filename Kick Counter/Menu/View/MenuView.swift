//
//  MenuView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI
import CoreData
import UIKit

enum MenuSelection: String {
    case counter
    case history
}

// TO-DO: Make a view model?
struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var bellyViewModel = BellyViewModel()
    @State var selection: MenuSelection? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                // MARK: Title
                Text("Kick Counter")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .padding()
                Spacer()
                
                // MARK: Belly
                BellyView(viewModel: bellyViewModel)
                    .padding()
                    .zIndex(5)
                Spacer()
                
                // MARK: Counter button
                NavigationLink(tag: MenuSelection.counter, selection: $selection) {
                    CounterView(viewModel: createCounterViewModel(),
                                bellyViewModel: createBellyViewModel())
                } label: {
                    EmptyView()
                }
                Button {
                    bellyViewModel.isBig = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selection = .counter
                    }
                } label: {
                    Text("Start Counting")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .padding()
                }
                
                // MARK: History button
                NavigationLink(tag: MenuSelection.history, selection: $selection) {
                    HistoryView(viewModel: createHistoryViewModel())
                } label: {
                    EmptyView()
                }
                Button {
                    bellyViewModel.isBig = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + BellyView.animationDuration - 0.2) {
                        selection = .history
                    }
                } label: {
                    Text("History")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .padding()
                }
            }
            .zIndex(1)
            .onAppear {
                bellyViewModel.isBig = true
            }
            .navigationBarHidden(true)
        }
    }
    
    private func createCounterViewModel() -> CounterViewModel {
        return CounterViewModel(viewContext: viewContext)
    }
    
    private func createBellyViewModel() -> BellyViewModel {
        return BellyViewModel()
    }
    
    private func createHistoryViewModel() -> HistoryViewModel {
        return HistoryViewModel(viewContext: viewContext)
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().previewDevice("iPhone 11").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
