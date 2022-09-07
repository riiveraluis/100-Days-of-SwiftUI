//
//  AddBookView.swift
//  Bookworm
//
//  Created by Luis Rivera Rivera on 3/17/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var showFormError = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book ", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    HStack {
                    Text("Rating:")
                        Spacer()
                        RatingView(rating: $rating)
                    }
                }
                
                Section {
                    Button("Save") {
                        if formHasCorrectInformation() {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.genre = genre
                            newBook.review = review
                            newBook.rating = Int16(rating)
                            newBook.date = Date.now
                            try? moc.save()
                            dismiss()
                        } else {
                            showFormError = true
                        }
                    }
                    .disabled(!formHasCorrectInformation())
                }
            }
            .navigationTitle("Add Book")
            .alert("Wrong Form", isPresented: $showFormError) {
                Button("Ok") {}
            } message: {
                Text("Please fill at least Title, Author and Genre fields.")
            }
        }
    }
    
    func formHasCorrectInformation() -> Bool {
        let isTitleValid = !title.trimmingCharacters(in: .whitespaces).isEmpty
        let isAuthorValid = !author.trimmingCharacters(in: .whitespaces).isEmpty
        let isGenreValid = !genre.isEmpty
        
        return isTitleValid && isAuthorValid && isGenreValid
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
