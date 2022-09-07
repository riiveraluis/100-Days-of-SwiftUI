//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Luis Rivera Rivera on 8/11/22.
//

import SwiftUI

struct UserDetailView: View {
//    let user: User
    let user: UserCached
    
    var body: some View {
        VStack {
            Image(systemName: "person")
                .resizable()
                .scaledToFill()
                .padding()
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                )
                .frame(width: 100, height: 100)

            Text(user.wrappedName)
                .font(.title.bold())
    
            VStack {
                HStack {
                    Text("Status:")
                        .font(.callout)
                    Group {
                        if user.isActive {
                            Text("Online")
                                .foregroundColor(.green)
                        } else {
                            Text("Offline")
                                .foregroundColor(.red)
                        }
                    }
                    .font(.callout.bold())
                }
                Text("Registered on \(user.wrappedRegistered.formatted())")
            }
            Divider()
            
                Form {
                    Section("Basic information") {
                        Text("Age: \(user.age)")
                        Text("Company: \(user.wrappedCompany)")
                        Text("Email: \(user.wrappedEmail)")
                        Text("Address: \(user.wrappedAddress)")
                    }
                    
                    Section("About") {
                        Text(user.wrappedAbout)
                            .multilineTextAlignment(TextAlignment.leading)
                    }
                    
                    Section("Tags") {
                        ForEach(user.wrappedTags, id: \.self) {
                            Text($0)
                        }
                    }
                }
            
            Group {
                if !user.wrappedFriends.isEmpty {
                    FriendListView(friends: user.wrappedFriends)
                }
            }
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            UserDetailView(user: UserCached(id: UUID(), isActive: true, name: "Luis Rivera", age: 24, company: "Luis Software", email: "luis@test.com", address: "Infinite Loop", about: "Aspiring Developer", registered: Date.now, tags: ["Developer", "Pet Lover"], friends: [Friend(id: UUID(), name: "Steve Jobs")]))
//        }
//    }
//}

struct FriendListView: View {
    let friends: [FriendsCached]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Friend List")
                .font(.title3.bold())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(friends, id: \.id) { friend in
                        VStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .padding()
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                }
                                .frame(width: 45, height: 45)
                            
                            Text(friend.wrappedName)
                                .font(.callout)
                        }
                    }
                }
                .padding(.top)
            }
        }
        .padding(.horizontal)
    }
}
