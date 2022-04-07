//
//  Kick+CoreDataProperties.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//
//

import Foundation
import CoreData

extension Kick {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kick> {
        return NSFetchRequest<Kick>(entityName: "Kick")
    }

    @NSManaged public var date: Date?
    @NSManaged public var session: Session?

}

extension Kick : Identifiable {

}
