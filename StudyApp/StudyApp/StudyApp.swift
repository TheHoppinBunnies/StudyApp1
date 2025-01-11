//
//  FlashCardApp.swift
//  FlashCard
//
//  Created by RPS on 18/10/24.
//

import SwiftUI
import FirebaseCore
@main
struct StudyApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate\

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SwiftUIView()
//                .onAppear {
//                    let _ = FirebaseApp.shared
//                }
//                .onAppear {
//                    flashcardsModel.fetchData()
//                    setsModel.fetchData()
//                }
        }
    }
}
