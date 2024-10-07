//
//  ReadingViewModel.swift
//  Skim
//
//  Created by Pedro Henriques on 07/10/2024.
//

import SwiftUI

class ReadingViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var displayedWord: String = "►"
    @Published var isReading = false
    @Published var hasEnded = false

    var articleBody: String
    var wpm: Double

    init(articleBody: String, wpm: Double) {
        self.articleBody = articleBody
        self.wpm = wpm
    }

    func readWords() {
        let words = articleBody.components(separatedBy: " ")
        if currentIndex < words.count {
            displayedWord = words[currentIndex]
            currentIndex += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + (60.0 / wpm)) {
                if self.isReading {
                    self.readWords()
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
        readWords()
    }
}
