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
    
    lazy private var session: Session = Session(context: viewContext)
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        session.date = timeStarted
    }
    
    @Published var goalMet = false
    @Published var progressText: String = "0/10 kicks"
    var timeStarted = Date()
    
    private let goal: Int = 10
    private var progress: Int = 0
    
    var cancellable: AnyCancellable?
    
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
    
    func cancel() {
        viewContext.delete(session)
        goalMet = true
    }
    
    private func updateGoalText() {
        progressText = String(describing: session.kicks?.count ?? 0) + "/\(goal)" + " kicks"
    }
    
}
