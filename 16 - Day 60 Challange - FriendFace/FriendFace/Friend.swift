//
//  Friend.swift
//  FriendFace
//
//  Created by Luis Rivera Rivera on 8/11/22.
//

import Foundation

struct Friend: Codable, Identifiable {
    let id: UUID
    let name: String
}
