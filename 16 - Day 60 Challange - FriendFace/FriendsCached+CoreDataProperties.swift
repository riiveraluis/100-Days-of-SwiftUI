//
//  FriendsCached+CoreDataProperties.swift
//  FriendFace
//
//  Created by Luis Rivera Rivera on 8/12/22.
//
//

import Foundation
import CoreData


extension FriendsCached {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsCached> {
        return NSFetchRequest<FriendsCached>(entityName: "FriendsCached")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var user: UserCached?

    public var wrappedID: UUID {
           id ?? UUID()
       }

       public var wrappedName: String {
           name ?? "Unknown Name"
       }
    
}

extension FriendsCached : Identifiable {

}
