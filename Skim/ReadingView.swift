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
                            viewModel.isReading.toggle()
                            if viewModel.isReading {
                                viewModel.readWords()
                            }
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
    }
}
