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
    var words: [String]
    var wpm: Double
    
    init(articleBody: String, wpm: Double) {
        self.articleBody = articleBody
        self.words = articleBody.components(separatedBy: " ")
        self.wpm = wpm
    }
    
    var surroundingWords: [String] {
        let leftIndex = max(currentIndex - 3, 0)
        let rightIndex = min(currentIndex + 3, words.count - 1)
        return Array(words[leftIndex...rightIndex])
    }
    
    func readWords() {
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
        currentIndex = 0
        hasEnded = false
        isReading = true
        readWords()
    }
    
    func pauseReading() {
        isReading = false
    }
    
    func resumeReading() {
        if !hasEnded {
            isReading = true
            readWords()
        }
    }
}
