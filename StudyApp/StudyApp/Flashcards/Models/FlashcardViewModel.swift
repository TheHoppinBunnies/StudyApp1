//
//  FlashcardViewModel.swift
//  StudyApp
//
//  Created by Othmane EL MARIKY on 2024-12-01.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FlashcardsViewModel: ObservableObject {

    @Published var flashcards = [Flashcard]()
    private var db = Firestore.firestore()

    func fetchData() {
        self.db.collection("flashcards")
//            .whereField("uid", isEqualTo: String(Auth.auth().currentUser?.uid ?? ""))
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }

                self.flashcards = documents.map { (queryDocumentSnapshot) -> Flashcard in
                    let data = queryDocumentSnapshot.data()
                    let _ = data["id"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let word = data["word"] as? String ?? ""
                    let translation = data["translation"] as? String ?? ""
                    let exampleSentence = data["exampleSentence"] as? String ?? ""
                    let set = data["set"] as? String ?? ""

                    return Flashcard(uid: uid, word: word, translation: translation, exampleSentence: exampleSentence, set: set)
                }
            }
    }
}

class FlashcardSetViewModel: ObservableObject {
    @Published var sets = [FlashcardSet]()

    private var db = Firestore.firestore()

    func fetchData() {
        self.db.collection("flashcardsSet")
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }

                self.sets = documents.map { (queryDocumentSnapshot) -> FlashcardSet in
                    let data = queryDocumentSnapshot.data()
                    let _ = data["id"] as? String ?? ""
//                    let uid = data["uid"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
//                    let flashcards = data["flashcards"] as? [Flashcard] ?? []

                    return FlashcardSet(title: title)
                    
                }
            }
    }
}
