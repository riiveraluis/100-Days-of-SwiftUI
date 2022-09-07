//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Luis Rivera Rivera on 8/11/22.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    @StateObject private var dataController = CoreDataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
