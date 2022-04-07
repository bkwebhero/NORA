//
//  CounterViewModel.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import Foundation
import CoreData
import Combine

class CounterViewModel: ObservableObject {
    
    // MARK: Dependency
    private var viewContext: NSManagedObjectContext
    
    // Create a kicking session
    // Make it lazy so we can access viewContext after view model has been initialized
    lazy private var session: Session = Session(context: viewContext)
    
    // MARK: Private state
    private let goal: Int = 10
    private var progress: Int = 0
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        // Record timestamp of when the session was started
        session.date = timeStarted
    }
    
    // MARK: Readables
    // Once goal has been met, we will dismiss the CounterView
    @Published var goalMet = false
    // Store observer for goalMet
    var cancellable: AnyCancellable?
    // Provides the text to the view
    @Published var progressText: String = "0/10 kicks"
    // Provides timestamp to view so it can show relative text
    var timeStarted = Date()
    
    // MARK: Public methods
    /// Create a kick and count it as progress towards goal
    /// Update text
    /// If goal has been met, dismiss the view
    func kick() {
        let kick = Kick(context: viewContext)
        kick.date = Date()
        kick.session = self.session
        updateGoalText()
        
        guard let kicks = session.kicks else { return }
        if kicks.count == goal {
            try? viewContext.save()
            goalMet = true
        }
    }
    
    /// Delete the session
    /// Dismiss the view
    func cancel() {
        viewContext.delete(session)
        goalMet = true
    }
    
    // MARK: Private methods
    /// Update the text with the kick count
    private func updateGoalText() {
        progressText = String(describing: session.kicks?.count ?? 0) + "/\(goal)" + " kicks"
    }
    
}
