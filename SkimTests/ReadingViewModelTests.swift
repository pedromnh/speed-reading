//
//  ReadingViewModelTests.swift
//  SkimTests
//
//  Created by Pedro Henriques on 10/10/2024.
//

import XCTest
@testable import Skim

class ReadingViewModelTests: XCTestCase {

    func testReadWords() {
        // Given (Arrange)
        let viewModel = ReadingViewModel(articleBody: "word1 word2 word3", wpm: 300)
        viewModel.isReading = true
        
        // Expectation to test async DispatchQueue behavior
        let expectation = XCTestExpectation(description: "Reading should end after all words are read")
        
        // When (Act)
        viewModel.readWords()
        
        // Then (Assert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(viewModel.displayedWord, "word3")
            XCTAssertTrue(viewModel.hasEnded)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

    func testRestartReading() {
        // Given (Arrange)
        let viewModel = ReadingViewModel(articleBody: "word1 word2", wpm: 300)
        
        // When (Act)
        viewModel.restartReading()
        
        // Then (Assert)
        XCTAssertEqual(viewModel.currentIndex, 1)
        XCTAssertTrue(viewModel.isReading)
    }
}
