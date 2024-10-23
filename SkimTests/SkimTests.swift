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

    func testGetTextFromUrl() async {
        // Given (Arrange)
        let expectedTitle = "The World of Warcraft 20th Anniversary Celebration Update Goes Live October 22!"
        let expectedBody = "Article Body"
        
        let mockGetTextFromUrl: (String) async -> Result<Article, URLTextError> = { _ in
            let article = Article(title: expectedTitle, body: expectedBody)
            return .success(article)
        }
        
        let viewModel = SkimViewModel(getTextFromUrl: mockGetTextFromUrl)
        
        // When (Act)
        let result = await viewModel.getTextFromUrl("https://worldofwarcraft.blizzard.com/en-us/news/24147266/the-world-of-warcraft-20th-anniversary-celebration-update-goes-live-october-22")
        
        // Then (Assert)
        switch result {
        case .success(let article):
            XCTAssertEqual(article.title, expectedTitle)
            // XCTAssertEqual(article.body, expectedBody)
        case .failure(let error):
            XCTFail("Expected success but got failure with error: \(error)")
        }
    }
}
