//
//  ArticleListTests.swift
//  SkimTests
//
//  Created by Pedro Henriques on 10/10/2024.
//

import XCTest
@testable import Skim

final class ArticleListTests: XCTestCase {
    func testLoadArticles() {
//        Given (Arrange)
        
//        When (Act)
        
        
//        Then (Assert)
    }
    
    func testSaveArticles() {
//        Given (Arrange)
        
//        When (Act)
        
        
//        Then (Assert)
    }
    
    
    func testDeleteArticle() {
//        Given (Arrange)
        
//        When (Act)
        
        
//        Then (Assert)
    }
    
    func testEstimatedReadingTime() {
        //        Given (Arrange)
        let viewModel = ArticleListViewModel()
        let body = "This is a test sentence."
        let expectedTime = "0 min 01 sec" // Considering WPM = 300
        
        //        When (Act)
        let result = viewModel.estimatedReadingTime(for: body)
        
        
        //        Then (Assert)
        XCTAssertEqual(result, expectedTime)
    }
    

}
