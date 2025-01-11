//
//  FlashcardDetailView.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FlashcardDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var word = ""
    @State private var translation = ""
    @State private var exampleSentence = ""
    
//    var flashcard: FlashcardEntity? // Make sure this is optional
    var flashcard: Flashcard

    var body: some View {
        NavigationView {
          ZStack {
            Color.blue.opacity(0.1)

            Form {
              Section(header: Text("Word/Phrase")
                .font(.headline)
                .foregroundColor(.blue)) {
                  TextField("Enter word", text: $word)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
              Section(header: Text("Translation")
                .font(.headline)
                .foregroundColor(.blue)) {
                  TextField("Enter translation", text: $translation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
              Section(header: Text("Example Sentence")
                .font(.headline)
                .foregroundColor(.blue)) {
                  TextField("Enter example sentence", text: $exampleSentence)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
            }
            .navigationBarTitle("Add Flashcard", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
              addFlashcard()
              presentationMode.wrappedValue.dismiss()
            }) {
              Text("Save")
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            })
            .onAppear {
                word = ""
                translation = ""
                exampleSentence = ""
            }
            .padding(.top, 20)
          }
          .ignoresSafeArea()
        }
        .accentColor(.blue) // Set accent color for navigation items
    }
    
    private func addFlashcard() {
        let db = Firestore.firestore()
        let cardRef = db.collection("flashcards").document()
        let cardData: [String: Any] = [
            "id": cardRef.documentID,
            "word": word,
            "translation": translation,
            "exampleSentence": exampleSentence,
            "uid": String(Auth.auth().currentUser?.uid ?? "")
        ]

        cardRef.setData(cardData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
//        if flashcard == nil {
//            // Creating a new flashcard
//            let newFlashcard = FlashcardEntity(context: viewContext)
//            newFlashcard.word = word
//            newFlashcard.translation = translation
//            newFlashcard.exampleSentence = exampleSentence
//        } else {
//            // Updating the existing flashcard
//            flashcard?.word = word
//            flashcard?.translation = translation
//            flashcard?.exampleSentence = exampleSentence
//        }
//        
//      do {
//            try viewContext.save()
//        } catch {
//            // Handle the error properly here
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
    }
}

//
//// Preview
//struct FlashcardDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashcardDetailView() // For adding a new flashcard
//    }
//}




