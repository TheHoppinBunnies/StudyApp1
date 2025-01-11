//
//  ContentView.swift
//  Flashcards
//
//  Created by Othmane EL MARIKY on 2024-11-03.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @ObservedObject private var viewModel = FlashcardsModel()
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader {
                    let size = $0.size
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(viewModel.flashcards) { flashcard in
                                FlashCardView(flashcard)
                                    .padding(.horizontal, 65)
                                    .frame(width: size.width)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .scaleEffect(scale(geometryProxy, scale: 0.1), anchor: .trailing)
                                            .rotationEffect(rotation(geometryProxy, rotation: 5))
                                            .offset(x: minX(geometryProxy))
                                            .offset(x: excessMinX(geometryProxy, offset: 10))
                                    }
                                    .zIndex(viewModel.flashcards.zIndex(flashcard))
                            }
                        }
                        .padding(.vertical, 15)
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                }
                .frame(height: 410)
            }
            .onAppear {
                viewModel.fetchData()
            }
            .navigationTitle("Flashcards")
        }
    }
    
    @ViewBuilder
    func FlashCardView(_ flashcard: Flashcard) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(flashcard.color.gradient)
    }
}

#Preview {
    ContentView()
}

func minX(_ proxy: GeometryProxy) -> CGFloat {
    let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
    return minX < 0 ? 0 : -minX
}

func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
    let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
    let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
    let progress = (maxX / width) - 1.0
    let cappedProgress = min(progress, limit)
    return cappedProgress
}

func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
    let progress = progress(proxy)
    
    return 1 - (progress * scale)
}

func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
    let progress = progress(proxy)
    
    return progress * offset
}

func rotation(_ proxy: GeometryProxy, rotation: CGFloat = 5) -> Angle {
    let progress = progress(proxy)
    
    return .init(degrees: progress * rotation)
}
