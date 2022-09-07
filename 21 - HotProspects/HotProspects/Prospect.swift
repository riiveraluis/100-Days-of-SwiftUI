//
//  Prospect.swift
//  HotProspects
//
//  Created by Luis Rivera Rivera on 4/19/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var dateMeet = Date.now
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    static let saveKey = "SavedData"
    let savePath = FileManager.documentsDirectory.appendingPathComponent(saveKey)
    
    //    init() {
    //        if let data = UserDefaults.standard.data(forKey: saveKey) {
    //            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
    //                people = decoded
    //                return
    //            }
    //        }
    //
    //        people = []
    //    }
    //
    //   private func save() {
    //        if let encoded = try? JSONEncoder().encode(people) {
    //            UserDefaults.standard.set(encoded, forKey: saveKey)
    //        }
    //    }
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath)
        } catch {
            print("Unable to save prospects.")
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}

