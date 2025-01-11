//
//  SetDetailView.swift
//  StudyApp
//
//  Created by Othmane EL MARIKY on 2025-01-11.
//

import SwiftUI

struct SetDetailView: View {
    @State private var searchText: String = ""
    @State private var showingAddCard = false
    @State private var showingQuiz = false
    @ObservedObject private var flashcardsModel = FlashcardsViewModel()
    @ObservedObject private var setsModel = FlashcardSetViewModel()

    @Environment(\.managedObjectContext) private var viewContext

    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var learnedCount = 0 // Track learned flashcards
    private var retentionRate: Double {
        let totalLearned = Double(learnedCount)
        let total = Double(flashcardsModel.flashcards.count)
        return total > 0 ? totalLearned / total : 0
    }
    var body: some View {
        VStack {
            // Search bar
            SearchBar(text: $searchText)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

            // List of flashcards
            List {
                ForEach(flashcardsModel.flashcards) { flashcard in
                    NavigationLink(destination: FlippableFlashcardView(flashcard: flashcard)) {
                        Text(flashcard.word)
                            .font(.headline)
                            .padding()
                            .background(Color.blue.opacity(0.3)) // Light background color
                            .cornerRadius(10)
                            .foregroundColor(.white) // Text color
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow
                    }
                }
//                .onDelete(perform: deleteFlashcards)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Flashcards")
            .background(Color.gray.opacity(0.05)) // Subtle background for the list

            // Navigation buttons at the bottom
            HStack {
                Button(action: {
                    showingAddCard.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.blue) // Changed button color to purple
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    showingQuiz.toggle() // Navigate to Quiz View
                }) {
                    Text("Start Quiz")
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(Color.blue) // Changed button color to purple
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1)) // Background for buttons
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddCard) {
            FlashcardDetailView(flashcard: Flashcard(uid: "", word: "", translation: "", exampleSentence: "", set: ""))
        }
//        .sheet(isPresented: $showingQuiz) {
//            QuizView(learnedCount: $learnedCount, flashcards: Array(flashcards), correctCount: $correctCount, wrongCount: $wrongCount)
//        }
    }
}

#Preview {
    SetDetailView()
}
