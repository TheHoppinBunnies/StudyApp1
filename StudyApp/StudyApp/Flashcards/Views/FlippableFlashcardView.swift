//
//  FlippableFlashcardView.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.
//

import SwiftUI

struct FlippableFlashcardView: View {
	let flashcard: Flashcard
	@State private var isFlipped = false // State to track if the card is flipped

	var body: some View {
		ZStack {
			Color.blue.opacity(0.1)
			VStack {
				Spacer()

				ZStack {
					// Front side of the card
					if !isFlipped {
						VStack {
							Text(flashcard.word)
								.font(.largeTitle)
								.fontWeight(.bold)
								.foregroundColor(.blue)
								.padding()
								.multilineTextAlignment(.center)
						}
						.frame(width: 300, height: 200)
						.background(Color.white)
						.cornerRadius(20)
						.shadow(radius: 10)
						.transition(.scale) // Scale transition for smoother flipping
					} else {
						// Back side of the card
						VStack {
							Text(flashcard.translation)
								.font(.title)
								.fontWeight(.medium)
								.foregroundColor(.blue) // Darker blue for translation
								.padding(.bottom, 5)

							Text(flashcard.exampleSentence)
								.font(.body)
								.foregroundColor(.black) // Black for contrast
								.multilineTextAlignment(.center)
								.padding()
						}
						.frame(width: 300, height: 200)
						.background(Color.white)
						.cornerRadius(20)
						.shadow(radius: 10)
						.transition(.scale) // Scale transition for smoother flipping
					}
				}
				.onTapGesture {
					withAnimation {
						isFlipped.toggle()
					}
				}

				Spacer()
			}
		}.ignoresSafeArea()
	}
}
