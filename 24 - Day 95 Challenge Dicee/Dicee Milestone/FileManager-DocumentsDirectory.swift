//
//  FileManager-DocumentsDirectory.swift
//  Dicee Milestone
//
//  Created by Luis Rivera Rivera on 7/1/22.
//

import Foundation
extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
