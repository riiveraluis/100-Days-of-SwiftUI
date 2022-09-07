//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Luis Rivera Rivera on 4/11/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
