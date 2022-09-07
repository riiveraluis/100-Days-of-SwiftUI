//
//  ContentView.swift
//  FriendFace
//
//  Created by Luis Rivera Rivera on 8/11/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //  @State private var users: [User] = []
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var users: FetchedResults<UserCached>
    @State private var isShowingNetworkErrorView = false
    
    var body: some View {
        NavigationView {
            if !isShowingNetworkErrorView {
                List(users, id: \.id) { user in
                    NavigationLink {
                        UserDetailView(user: user)
                    } label: {
                        UserRow(user: user)
                    }
                }
                .refreshable {
                    await loadUsers()
                }
                .navigationTitle("Friends")
            } else {
                NetworkErrorView {
                    await loadUsers()
                }
            }
        }
        .onAppear {
            Task {
                await loadUsers()
            }
        }
    }
    
    func loadUsers() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let decodedUsers = try? decoder.decode([User].self, from: data) {
                let users = decodedUsers
                await MainActor.run(body: {
                    updateLocalStorage(with: users)
                })
                
                isShowingNetworkErrorView = false
            }
        } catch {
            isShowingNetworkErrorView = true
            print("Could not download data. -> \(error.localizedDescription)")
        }
    }
    
    func updateLocalStorage(with users: [User]) {
        for user in users {
            let newCachedUser = UserCached(context: moc)
            newCachedUser.about = user.about
            newCachedUser.address = user.address
            newCachedUser.age = Int16(user.age)
            newCachedUser.company = user.company
            newCachedUser.email = user.email
            newCachedUser.id = user.id
            newCachedUser.isActive = user.isActive
            newCachedUser.name = user.name
            newCachedUser.registered = user.registered
            newCachedUser.tags = user.tags.joined(separator: ",")
            
            for friend in user.friends {
                let newCachedFriend = FriendsCached(context: moc)
                newCachedFriend.id = friend.id
                newCachedFriend.name = friend.name
                
                newCachedUser.addToFriends(newCachedFriend)
            }
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UserRow: View {
    let user: UserCached
    
    var body: some View {
        HStack {
            Group {
                if user.isActive {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 10, height: 10)
                } else {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 10, height: 10)
                }
            }
            Text(user.wrappedName)
        }
    }
}

struct NetworkErrorView: View {
    let retryLoad: () async -> ()
    @State private var isShowingProgressView = false
    var body: some View {
        VStack {
            Group {
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Network Not Available")
            }
            .foregroundColor(.black.opacity(0.5))
            
            Group {
                if !isShowingProgressView {
                    Button("Try Again") {
                        isShowingProgressView.toggle()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                            isShowingProgressView.toggle()
                        }
                        
                        Task {
                            await self.retryLoad()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    ProgressView()
                }
            }
        }
    }
}
