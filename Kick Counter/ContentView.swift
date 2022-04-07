//
//  ContentView.swift
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

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var bellyViewModel = BellyViewModel()
    @State var selection: MenuSelection? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Kick Counter")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .padding()
                
                Spacer()
                
                // Belly
                BellyView(viewModel: bellyViewModel)
                    .padding()
                    .zIndex(5)
                Spacer()
                
                // Counter button
                NavigationLink(tag: MenuSelection.counter, selection: $selection) {
                    CounterView(viewModel: createCounterViewModel(),
                                bellyViewModel: createBellyViewModel())
                } label: {
                    EmptyView()
                }
                Button {
                    UINavigationBar.setAnimationsEnabled(false)
                    bellyViewModel.isVisible = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selection = .counter
                    }
                } label: {
                    Text("Start Counting")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .padding()
                }
                
                // History button
                NavigationLink(tag: MenuSelection.history, selection: $selection) {
                    HistoryView(viewModel: createHistoryViewModel())
                } label: {
                    EmptyView()
                }
                Button {
                    UINavigationBar.setAnimationsEnabled(true)
                    bellyViewModel.isVisible = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                bellyViewModel.isVisible = true
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


extension UIColor {
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
}
