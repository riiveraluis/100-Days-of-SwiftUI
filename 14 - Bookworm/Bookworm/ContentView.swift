//
//  ContentView.swift
//  Bookworm
//
//  Created by Luis Rivera Rivera on 3/17/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            Group {
                if books.isEmpty {
                    EmptyListView()
                } else {
                    List {
                        ForEach(books) { book in
                            NavigationLink {
                                DetailView(book: book)
                            } label: {
                                HStack {
                                    EmojiRatingView(rating: book.rating)
                                        .font(.largeTitle)
                                    
                                    VStack(alignment: .leading) {
                                        Text(book.title ?? "Unknown title")
                                            .font(.headline)
                                            .foregroundColor(book.rating == 1 ? .red : .black)
                                        
                                        Text(book.author ?? "Unknown Author")
                                            .foregroundColor(.secondary)
                                        
                                        Text("Added on \(book.date?.formatted(date: .numeric, time: .omitted) ?? "Unknown Date")")
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteBooks)
                    }
                }
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !books.isEmpty {
                        EditButton()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct EmptyListView: View {
    var body: some View {
        VStack {
            Image(systemName: "books.vertical")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 100, height: 100)
            
            Text("Start by adding a book pressing \(Image(systemName: "plus")) icon")
                .bold()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
