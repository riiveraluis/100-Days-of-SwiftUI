//
//  UserCached+CoreDataProperties.swift
//  FriendFace
//
//  Created by Luis Rivera Rivera on 8/12/22.
//
//

import Foundation
import CoreData


extension UserCached {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCached> {
        return NSFetchRequest<UserCached>(entityName: "UserCached")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friends: NSSet?

    public var wrappedID: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedCompany: String {
        company ?? "Unknown Company"
    }
    
    public var wrappedEmail: String {
        email ?? "Unknown Email"
    }
    
    public var wrappedAddress: String {
        address ?? "Unknown Address"
    }
    
    public var wrappedAbout: String {
        about ?? "Unknown About"
    }
    
    public var wrappedRegistered: Date {
        registered ?? Date.now
    }
    
    public var wrappedTags: [String] {
        if !tags!.isEmpty {
            return tags!.components(separatedBy: ",")
        } else {
            return []
        }
    }
    
    public var wrappedFriends: [FriendsCached] {
        let set = friends as? Set<FriendsCached> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for friends
extension UserCached {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: FriendsCached)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: FriendsCached)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension UserCached : Identifiable {

}
