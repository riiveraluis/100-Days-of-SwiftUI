//
//  People.swift
//  Face Reminder
//
//  Created by Luis Rivera Rivera on 6/17/22.
//

import SwiftUI
import CoreLocation

struct PhotoLocation: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

class Person: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String = ""
    var photo: Data = Data()
    let photoLocation: PhotoLocation?
    
    init(id: UUID, name: String, photo: Data, photoLocation: PhotoLocation?) {
        self.id = id
        self.name = name
        self.photo = photo
        self.photoLocation = photoLocation
    }

    static func ==(lhs: Person, rhs: Person) -> Bool{
        lhs.id == rhs.id
    }
}

@MainActor class People: ObservableObject {
    @Published private(set) var people: [Person]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("savedPeople")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Person].self, from: data)
        } catch {
        people = []
    }
    }
    
    func add(_ newPerson: Person) {
        people.append(newPerson)
        save()
    }
    
    func save() {
        do {
            let encodedPeople = try JSONEncoder().encode(people)
            try encodedPeople.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Could not save data of the people list.")
        }
    }
    
    func remove(_ person: Person) {
        let indexOfPersonToBeRemoved = people.firstIndex(of: person)!
        people.remove(at: indexOfPersonToBeRemoved)
        save()
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
