//
//  Kick_CounterApp.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI

@main
struct Kick_CounterApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        UINavigationBar.appearance().tintColor = UIColor(.primary)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
