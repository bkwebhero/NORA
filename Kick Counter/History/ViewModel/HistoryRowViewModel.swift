//
//  HistoryRowViewModel.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import Foundation

class HistoryRowViewModel: ObservableObject {
    
    // MARK: Dependency
    private var session: Session
    
    init(session: Session) {
        self.session = session
        
        dateString = getDateString()
        timeString = getTimeString()
        durationString = getDurationString()
    }
    
    // MARK: Readables
    @Published var dateString: String = ""
    @Published var timeString: String = ""
    @Published var durationString: String = ""
    
    // MARK: Private methods
    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        return dateFormatter.string(from: session.date ?? Date.distantPast)
    }
    
    private func getTimeString() -> String {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "h:mm a"
        return dateFormatter2.string(from: session.date ?? Date.distantPast)
        
    }
    
    private func getDurationString() -> String {
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: session.date ?? Date.distantPast)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: session.sorted.last?.date ?? Date.distantPast)
        let hours = calendar.dateComponents([.hour], from: timeComponents, to: nowComponents).hour ?? 0
        let minutes = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute ?? 0
        let hourSuffix = hours == 1 ? " hour" : " hours"
        let minuteSuffix = minutes == 1 ? " minute" : " minutes"
        return String(describing: hours) + hourSuffix + ", " + String(describing: minutes) + minuteSuffix
    }
    
}
