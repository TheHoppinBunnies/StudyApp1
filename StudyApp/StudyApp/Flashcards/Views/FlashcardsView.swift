//
//  ContentView.swift
//  FlashCard
//
//  Created by RPS on 18/10/24.
//

import SwiftUI
import CoreData

struct FlashcardsView: View {
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
    var names = ["Set theory", "Geography", "French revolution"]

    var body: some View {
        VStack {
            TopBar()

            VStack {
                ScrollView(.vertical) {
                    VStack(spacing: 30) {
                        ForEach(names, id: \.self) { set in
//                            NavigationLink(destination: SetDetailView()) {
                            FlashcardSetView(set)
//                            }
                        }
                    }
                    .padding()
                }
            }.padding(.top, -250)
        }
    }

    @ViewBuilder
    func FlashcardSetView(_ set: String) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.cyan)
                .frame(height: 150)
                .shadow(color: .black, radius: 3)
                .overlay(
                    Button {
                        // Quiz
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 80, height: 40)
                            .foregroundColor(.minto)
                            .shadow(color: .black, radius: 3)
                            .padding()
                            .overlay(alignment: .center) {
                                Text("QUIZ")
                                    .fontWeight(.black)
                                    .foregroundStyle(.black)
                            }
                    }, alignment: .bottomTrailing)
                .overlay(
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .padding()
                    ,alignment: .topTrailing)
                .overlay(
                    Text(set)
                        .font(.title)
                        .fontWeight(.black)
                        .padding()
                    , alignment: .topLeading)

        }

    }
//    private func deleteFlashcards(at offsets: IndexSet) {
//        for index in offsets {
//            let flashcard = flashcards[index]
//            viewContext.delete(flashcard)
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            print("Error saving context after deleting flashcard: \(error)")
//        }
//    }
}
#Preview {
    FlashcardsView()
}

//VStack {
//    // Search bar
//    SearchBar(text: $searchText)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
//
//    // List of flashcards
//    List {
//        ForEach(filteredFlashcards, id: \.self) { flashcard in
//            NavigationLink(destination: FlippableFlashcardView(flashcard: flashcard)) {
//                Text(flashcard.word ?? "Unknown Word")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.blue.opacity(0.3)) // Light background color
//                    .cornerRadius(10)
//                    .foregroundColor(.white) // Text color
//                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow
//            }
//        }
//        .onDelete(perform: deleteFlashcards)
//    }
//    .listStyle(PlainListStyle())
//    .navigationTitle("Flashcards")
//    .background(Color.gray.opacity(0.05)) // Subtle background for the list
//
//    // Navigation buttons at the bottom
//    HStack {
//        Button(action: {
//            showingAddCard.toggle()
//        }) {
//            Image(systemName: "plus")
//                .font(.system(size: 24))
//                .padding()
//                .background(Color.blue) // Changed button color to purple
//                .foregroundColor(.white)
//                .cornerRadius(10)
//        }
//        Button(action: {
//            showingQuiz.toggle() // Navigate to Quiz View
//        }) {
//            Text("Start Quiz")
//                .fontWeight(.semibold)
//                .padding(10)
//                .background(Color.blue) // Changed button color to purple
//                .foregroundColor(.white)
//                .cornerRadius(10)
//        }
//    }
//    .padding()
//    .background(Color.blue.opacity(0.1)) // Background for buttons
//    .cornerRadius(10)
//    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
//}
//.navigationBarTitleDisplayMode(.inline)
//.sheet(isPresented: $showingAddCard) {
//    FlashcardDetailView(flashcard: nil) // Pass nil for new flashcard
//}
//.sheet(isPresented: $showingQuiz) {
//    QuizView(learnedCount: $learnedCount, flashcards: Array(flashcards), correctCount: $correctCount, wrongCount: $wrongCount)
//}


//import SwiftUI
//import CoreData
//
//struct FlashcardsView: View {
//    @State private var searchText: String = ""
//    @State private var showingAddCard = false
//    @State private var showingQuiz = false
//    @ObservedObject private var flashcardsModel = FlashcardsViewModel()
//    @ObservedObject private var setsModel = FlashcardSetViewModel()
//
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @State private var correctCount = 0
//    @State private var wrongCount = 0
//    @State private var learnedCount = 0 // Track learned flashcards
//    private var retentionRate: Double {
//        let totalLearned = Double(learnedCount)
//        let total = Double(flashcardsModel.flashcards.count)
//        return total > 0 ? totalLearned / total : 0
//    }
//
//    var body: some View {
//        VStack {
//            TopBar()
//
//            VStack {
//                ScrollView(.vertical) {
//                    VStack(spacing: 30) {
//                        ForEach(setsModel.sets) { set in
////                            NavigationLink(destination: SetDetailView(set: set)) {
//                                FlashcardSetView(set)
////                            }
//                        }
//                    }
//                    .padding()
//                }
//            }.padding(.top, -250)
//        }.onAppear {
//            setsModel.fetchData()
//            flashcardsModel.fetchData()
//        }
//    }
//
//    @ViewBuilder
//    func FlashcardSetView(_ set: FlashcardSet) -> some View {
//        VStack {
//            RoundedRectangle(cornerRadius: 20)
//                .foregroundStyle(.cyan)
//                .frame(height: 150)
//                .shadow(color: .black, radius: 3)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                        .frame(width: 80, height: 40)
//                        .foregroundColor(.mint)
//                        .shadow(color: .black, radius: 3)
//                        .padding()
//                    , alignment: .bottomTrailing)
//                .overlay(
//                    Text(set.title)
//                        .font(.title2)
//                        .padding()
//                    , alignment: .topLeading)
//
//        }
//
//    }
////    private func deleteFlashcards(at offsets: IndexSet) {
////        for index in offsets {
////            let flashcard = flashcards[index]
////            viewContext.delete(flashcard)
////        }
////        do {
////            try viewContext.save()
////        } catch {
////            print("Error saving context after deleting flashcard: \(error)")
////        }
////    }
//}
//#Preview {
//    FlashcardsView()
//}
//
//
//
////VStack {
////    // Search bar
////    SearchBar(text: $searchText)
////        .padding()
////        .background(Color.white)
////        .cornerRadius(10)
////        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
////
////    // List of flashcards
////    List {
////        ForEach(filteredFlashcards, id: \.self) { flashcard in
////            NavigationLink(destination: FlippableFlashcardView(flashcard: flashcard)) {
////                Text(flashcard.word ?? "Unknown Word")
////                    .font(.headline)
////                    .padding()
////                    .background(Color.blue.opacity(0.3)) // Light background color
////                    .cornerRadius(10)
////                    .foregroundColor(.white) // Text color
////                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow
////            }
////        }
////        .onDelete(perform: deleteFlashcards)
////    }
////    .listStyle(PlainListStyle())
////    .navigationTitle("Flashcards")
////    .background(Color.gray.opacity(0.05)) // Subtle background for the list
////
////    // Navigation buttons at the bottom
////    HStack {
////        Button(action: {
////            showingAddCard.toggle()
////        }) {
////            Image(systemName: "plus")
////                .font(.system(size: 24))
////                .padding()
////                .background(Color.blue) // Changed button color to purple
////                .foregroundColor(.white)
////                .cornerRadius(10)
////        }
////        Button(action: {
////            showingQuiz.toggle() // Navigate to Quiz View
////        }) {
////            Text("Start Quiz")
////                .fontWeight(.semibold)
////                .padding(10)
////                .background(Color.blue) // Changed button color to purple
////                .foregroundColor(.white)
////                .cornerRadius(10)
////        }
////    }
////    .padding()
////    .background(Color.blue.opacity(0.1)) // Background for buttons
////    .cornerRadius(10)
////    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
////}
////.navigationBarTitleDisplayMode(.inline)
////.sheet(isPresented: $showingAddCard) {
////    FlashcardDetailView(flashcard: nil) // Pass nil for new flashcard
////}
////.sheet(isPresented: $showingQuiz) {
////    QuizView(learnedCount: $learnedCount, flashcards: Array(flashcards), correctCount: $correctCount, wrongCount: $wrongCount)
////}

struct TopBar: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Flashcards")
                    .fontDesign(.rounded)
                    .font(.system(size: 35))
                    .bold()
                    .foregroundStyle(.teal)
                
                Text("Pick a set to practice")
                    .fontDesign(.rounded)
                    .font(.system(size: 20))
                    .fontWeight(.regular)
            }
            .vSpacing(.top)
            .hSpacing(.leading)
            .padding()
            
            Image("profile_pic")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55)
                .clipShape(Circle())
                .shadow(color: .black, radius: 5)
                .padding()
        }
    }
}
