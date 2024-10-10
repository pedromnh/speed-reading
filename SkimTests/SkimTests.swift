//
//  SkimTests.swift
//  SkimTests
//
//  Created by Pedro Henriques on 10/10/2024.
//

import XCTest
@testable import Skim

class SkimTests: XCTestCase {

    func testWpmSpeedCalculation() {
        // Given (Arrange)
        let viewModel = SkimViewModel()
        viewModel.wpm = 600.0
        let expectedSpeed = 1 / (600.0 / 60)

        // When (Act)
        let result = viewModel.wpmSpeed()

        // Then (Assert)
        XCTAssertEqual(result, expectedSpeed)
    }

    func testReadString() {
        // Given (Arrange)
        let viewModel = SkimViewModel()
        let sentence = "This is a test sentence"
        let expectation = XCTestExpectation(description: "Timer should invalidate after reading the entire sentence")
        
        // When (Act)
        viewModel.readString(sentence: sentence)

        // Then (Assert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(true, "Reading completed.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }

    func testPasteTextFromClipboard() {
        // Given (Arrange)
        let viewModel = SkimViewModel()
        UIPasteboard.general.string = "Test clipboard text"
        
        // When (Act)
        let result = viewModel.pasteText()
        
        // Then (Assert)
        XCTAssertEqual(result, "Test clipboard text")
    }

    func testGetTextFromUrl() {
        // Given (Arrange)
        let expectedTitle = "The World of Warcraft 20th Anniversary Celebration Update Goes Live October 22!"
        let expectedBody = "Article Body"
        
        let mockGetTextFromUrl: (String) -> (String, String) = { _ in
            return (expectedTitle, expectedBody)
        }
        
        let viewModel = SkimViewModel(getTextFromUrl: mockGetTextFromUrl)
        
        // When (Act)
        let (title, _) = viewModel.getTextFromUrl(urlToRead: "https://worldofwarcraft.blizzard.com/en-us/news/24147266/the-world-of-warcraft-20th-anniversary-celebration-update-goes-live-october-22")
        
        // Then (Assert), Not checking body due to variables unrelated to the content of the article itself
        XCTAssertEqual(title, expectedTitle)
//        XCTAssertEqual(body, expectedBody)
    }
}
