//
//  ContentView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI
import CoreData
import UIKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Spacer()
                BellyView()
                    .padding()
                    .navigationBarTitle(Text("Kick Counter"))
                Spacer()
                NavigationLink(destination: NavigationLazyView(CounterView(viewModel: CounterViewModel(viewContext: viewContext)))) {
                        Text("Start Counting")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .padding()
                    }
                NavigationLink(destination: NavigationLazyView(HistoryView(viewModel: HistoryViewModel(viewContext: viewContext)))) {
                        Text("History")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .padding()
                    }
            }
        }
    }
}

// Fix for NavigationLink views reusing the same view model
// https://stackoverflow.com/questions/57594159/swiftui-navigationlink-loads-destination-view-immediately-without-clicking
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
