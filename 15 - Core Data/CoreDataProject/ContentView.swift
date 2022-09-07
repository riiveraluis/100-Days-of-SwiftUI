//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Luis Rivera Rivera on 8/10/22.
//

import SwiftUI
import CoreData

// Why self works
struct Student: Hashable {
    let name: String
}

struct StudentView: View {
    let students = [Student(name: "Luis Rivera Rivera"), Student(name: "Ted Lasso")]
    
    var body: some View {
        List(students, id: \.self) { student in
            Text(student.name)
        }
    }
}

struct WizardView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    var body: some View {
        VStack {
            List(wizards, id: \.self) { wizard in
                Text(wizard.name ?? "Unknown")
            }
            
            Button("Add") {
                let wizard = Wizard(context: moc)
                wizard.name = "Harry Potter"
            }
            
            Button("Save") {
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ShipView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var shipAdded = false
    @State private var isShowingFilters = false
    @State private var filterType: FilterType = .all
    
    enum FilterType {
        case all, starwars, startrek, begingWithE, notBeginWithE
    }
    
    var predicate: NSPredicate? {
        switch filterType {
            
        case .all:
            return nil
            
        case .starwars:
            return NSPredicate(format: "universe == %@", "Star Wars")
        case .startrek:
            return NSPredicate(format: "universe == %@", "Star Trek")
        case .begingWithE:
            return NSPredicate(format: "name BEGINSWITH[c] %@", "e")
        case .notBeginWithE:
            return NSPredicate(format: "NOT name BEGINSWITH[c] %@", "e")
            
        }
    }
    
    var body: some View {
        VStack {
            
            FilteredShipList(predicate: predicate)
            
            if !shipAdded {
                Button("Add Examples") {
                    let ship1 = Ship(context: moc)
                    ship1.name = "Enterprise"
                    ship1.universe = "Star Trek"
                    
                    let ship2 = Ship(context: moc)
                    ship2.name = "Defiant"
                    ship2.universe = "Star Trek"
                    
                    let ship3 = Ship(context: moc)
                    ship3.name = "Millennium Falcon"
                    ship3.universe = "Star Wars"
                    
                    let ship4 = Ship(context: moc)
                    ship4.name = "Executor"
                    ship4.universe = "Star Wars"
                    
                    try? moc.save()
                    
                    shipAdded.toggle()
                }
            } else {
                Button("Show Filters") {
                    isShowingFilters.toggle()
                }
            }
        }
        .confirmationDialog("Filters Options", isPresented: $isShowingFilters) {
            if filterType != .all {
                Button("Show all") {
                    filterType = .all
                }
            }
            
            Button("Show Star Wars Ships") {
                filterType = .starwars
            }
            
            Button("Show Star Trek Ships") {
                filterType = .startrek
            }
            
            Button("Show Ships starting with letter E") {
                filterType = .begingWithE
            }
            
            Button("Show Ships not starting with letter E") {
                filterType = .notBeginWithE
            }
        } message: {
            Text("Filter Options")
        }
        
    }
}

struct FilteredShipList:  View {
    @FetchRequest var ships: FetchedResults<Ship>
    
    var body: some View {
        List(ships, id : \.self) { ship in
            Text(ship.name ?? "Unknown name")
        }
    }
    
    init(predicate: NSPredicate?) {
        _ships = FetchRequest<Ship>(sortDescriptors: [], predicate: predicate)
    }
}

enum PredicateType: String, CaseIterable {
    case beginsWith = "Begins with"
    case notBeginsWith = "Not Begings With"
}

struct SingerView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter  = "A"
    @State private var predicateType: PredicateType = .beginsWith
    
    
    var body: some View {
        VStack {
            
            FilteredList(filterKey: "lastName", sortDescriptors: [SortDescriptor<Singer>(\.lastName, order: .forward)], predicateType: predicateType, filterValue: lastNameFilter) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? moc.save()
            }
            
            Button("Show Last name's with A") {
                lastNameFilter = "A"
            }
            
            Button("Show Last name's with S") {
                lastNameFilter = "S"
            }
            
            Picker("Predicate Type", selection: $predicateType) {
                ForEach(PredicateType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
        }
    }
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }
    
    init(filterKey: String, sortDescriptors: [SortDescriptor<T>] = [], predicateType: PredicateType, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        let predicate: String
        
        switch predicateType {
        case .beginsWith:
            predicate = "%K BEGINSWITH[c] %@"
        case .notBeginsWith:
            predicate = "NOT %K BEGINSWITH[c] %@"
        }
        
        _fetchRequest = FetchRequest<T>(sortDescriptors: sortDescriptors, predicate: NSPredicate(format: predicate, filterKey, filterValue))
        self.content = content
    }
}

struct CandyAndCountryRelationships: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(country.wrappedFullName) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"
                
                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"
                
                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"
                
                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"
                
                let candy5 = Candy(context: moc)
                candy5.name = "Besito de coco"
                candy5.origin = Country(context: moc)
                candy5.origin?.shortName = "PR"
                candy5.origin?.fullName = "Puerto Rico"
                try? moc.save()
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Wizard Example", destination: WizardView())
                NavigationLink("Filtering with NSPredicate", destination: ShipView())
                NavigationLink("Singer Example", destination: SingerView())
                NavigationLink("Candies and Countries", destination: CandyAndCountryRelationships())
            }
            .navigationTitle("Core Data Project")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SingerView()
    }
}
