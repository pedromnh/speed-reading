//
//  ReadingView.swift
//  Skim
//
//  Created by Pedro Henriques on 29/09/2023.
//
import SwiftUI

struct ReadingView: View {
    @StateObject var viewModel: ReadingViewModel
    
    init(articleBody: String, wpm: Double) {
        _viewModel = StateObject(wrappedValue: ReadingViewModel(articleBody: articleBody, wpm: wpm))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.displayedWord)
                .font(.largeTitle)
                .onTapGesture {
                    if viewModel.hasEnded {
                        viewModel.restartReading()
                    } else {
                        withAnimation {
                            if viewModel.isReading {
                                viewModel.pauseReading()
                            } else {
                                viewModel.resumeReading()
                            }
                        }
                    }
                }
            
            if !viewModel.isReading || viewModel.hasEnded {
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(viewModel.surroundingWords.enumerated()), id: \.offset) { index, word in
                                Text(word)
                                    .font(.title)
                                    .opacity(word == viewModel.displayedWord ? 1.0 : 0.5)
                                    .id(index)
                                    .onTapGesture {
                                        viewModel.currentIndex = index
                                    }
                            }
                        }
                        .padding()
                        .onChange(of: viewModel.currentIndex) { newIndex in
                            viewModel.displayedWord = viewModel.words[newIndex]
                            withAnimation(.easeInOut(duration: 0.3)) {
                                scrollProxy.scrollTo(newIndex, anchor: .center)
                            }
                        }
                        .gesture(DragGesture()
                            .onEnded { value in
                                let direction = value.translation.width > 0 ? -4 : 4
                                let newIndex = viewModel.currentIndex + direction
                                if newIndex >= 0 && newIndex < viewModel.words.count {
                                    viewModel.currentIndex = newIndex
                                    viewModel.pauseReading()
                                }
                            }
                        )
                    }
                }
            }
            
            if viewModel.hasEnded {
                Button(action: {
                    viewModel.restartReading()
                }) {
                    Text("Replay")
                }
            }
        }
        .onAppear {
            viewModel.displayedWord = viewModel.words[viewModel.currentIndex]
        }
    }
}
