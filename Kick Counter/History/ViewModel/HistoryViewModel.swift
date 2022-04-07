//
//  HistoryViewModel.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import Foundation
import CoreData
import Combine

class HistoryViewModel: ObservableObject  {
    
    private var viewContext: NSManagedObjectContext
    @Published var sessions = [Session]()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        sessions = fetchAllSessions()
    }
    
    private func fetchAllSessions() -> [Session] {
        let fetchRequest: NSFetchRequest<Session>
        fetchRequest = Session.fetchRequest()
        guard let objects = try? viewContext.fetch(fetchRequest) else { return [] }
        return objects.sorted { $0.date ?? Date.distantPast > $1.date ?? Date.distantPast }
    }
    
    func delete(at indices: IndexSet) {
        for index in indices {
            let session = sessions[index]
            viewContext.delete(session)
            sessions.remove(at: index)
            try? viewContext.save()
        }
    }
    
}
