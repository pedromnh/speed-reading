//
//  ReadingView.swift
//  Skim
//
//  Created by Pedro Henriques on 29/09/2023.
//
import SwiftUI

struct ReadingView: View {
    @Environment(\.colorScheme) var colorScheme
    var wpm: Double
    var articleBody: String
    @State private var currentIndex = 0
    @State private var isReading = false
    @State private var displayedWord: String = "►"
    @State private var hasEnded = false

    var body: some View {
        VStack {
            Text(displayedWord)
                .font(.largeTitle)
                .onTapGesture {
                    if hasEnded {
                        restartReading()
                    } else {
                        withAnimation {
                            if isReading {
                                isReading = false
                            } else {
                                isReading = true
                                if currentIndex >= articleBody.components(separatedBy: " ").count {
                                    currentIndex = 0
                                }
                                readWords(wpm: wpm)
                            }
                        }
                    }
                }
                .foregroundColor((isReading || hasEnded) ? (colorScheme == .dark ? .white : .black) : .blue)

            if hasEnded {
                Button(action: {
                    restartReading()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Replay")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                }
                .transition(.opacity)
                .padding()
            }
        }
    }

    func readWords(wpm: Double) {
        let words = articleBody.components(separatedBy: " ")

        if currentIndex < words.count {
            displayedWord = words[currentIndex]
            currentIndex += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + (60.0 / wpm)) {
                if isReading {
                    readWords(wpm: wpm)
                }
            }
        } else {
            hasEnded = true
            isReading = false
        }
    }

    func restartReading() {
        displayedWord = "►"
        currentIndex = 0
        hasEnded = false
        isReading = true
        readWords(wpm: wpm)
    }
}

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView(wpm: 200, articleBody: "This is a test phrase for preview.")
    }
}
