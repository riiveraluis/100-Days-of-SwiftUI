//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Luis Rivera Rivera on 3/17/22.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
