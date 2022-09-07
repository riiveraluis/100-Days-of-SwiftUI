//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Luis Rivera Rivera on 7/5/22.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    
    static let saveKey = "Favorites"
    let savePath = FileManager.documentsDirectory.appendingPathComponent(saveKey)
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            resorts = try JSONDecoder().decode(Set<String>.self, from: data)
        } catch {
            resorts = []
            print("Could not load favorites")
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        do {
            let encodedResort = try JSONEncoder().encode(resorts)
                try encodedResort.write(to: savePath)
        } catch {
            print("Could not save the resorts!")
        }
    }
}

extension FileManager { // Move this later
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
