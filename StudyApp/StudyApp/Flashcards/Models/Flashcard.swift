//
//  Flashcard.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.
//

import Foundation
import SwiftUI
import CoreData

struct Flashcard: Identifiable {
    var id: UUID = UUID()
    var uid: String
    var word: String
    var translation: String
    var exampleSentence: String
    var set: String

    init(uid: String, word: String, translation: String, exampleSentence: String, set: String) {
        self.id = UUID()
        self.uid = uid
        self.word = word
        self.translation = translation
        self.exampleSentence = exampleSentence
        self.set = set
    }
}

struct FlashcardSet: Identifiable {
    var id: UUID = UUID()
    var title: String
//    var flashcards: [Flashcard]

    init(title: String) {
        self.id = UUID()
        self.title = title
//        self.flashcards = flashcards
    }
}
