//
//  Session+CoreDataProperties.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//
//

import Foundation
import CoreData

extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var date: Date?
    @NSManaged public var kicks: NSSet?

}

// MARK: Generated accessors for kicks
extension Session {

    @objc(addKicksObject:)
    @NSManaged public func addToKicks(_ value: Kick)

    @objc(removeKicksObject:)
    @NSManaged public func removeFromKicks(_ value: Kick)

    @objc(addKicks:)
    @NSManaged public func addToKicks(_ values: NSSet)

    @objc(removeKicks:)
    @NSManaged public func removeFromKicks(_ values: NSSet)

}

extension Session : Identifiable {

}
