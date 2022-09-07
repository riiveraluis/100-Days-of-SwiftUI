//
//  FileManager.swift
//  HotProspects
//
//  Created by Luis Rivera Rivera on 8/25/22.
//

import Foundation

extension FileManager { // Move this later
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
