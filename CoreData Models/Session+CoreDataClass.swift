//
//  Session+CoreDataClass.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//
//

import Foundation
import CoreData

@objc(Session)
public class Session: NSManagedObject {

    var sorted: [Kick] {
        return (kicks as? Set<Kick>)?.sorted(by: { $0.date ?? Date.distantPast < $1.date ?? Date.distantPast }) ?? []
    }
    
}
