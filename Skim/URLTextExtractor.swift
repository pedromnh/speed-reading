//
//  URLTextExtractor.swift
//  Skim
//
//  Created by Pedro Henriques on 07/10/2024.
//

import SwiftUI
import SwiftSoup
import OSLog

class URLTextExtractor {
    static func getTextFromUrl(urlToRead: String) -> Result<Article, URLTextError> {
        guard let url = URL(string: urlToRead) else {
            Logger.urlProcessing.error("Invalid URL: \(urlToRead)")
            return .failure(.invalidURL)
        }
        
        do {
            let contentOfURL = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(contentOfURL)
            
            let title = try doc.select("h1, h2").first()?.text() ?? "No Title Found"
            let bodyText = try doc.text()
            
            Logger.urlProcessing.info("Successfully fetched content from URL: \(urlToRead)")
            
            let article = Article(title: title, body: bodyText)
            return .success(article)
        } catch let fetchError as NSError {
            Logger.urlProcessing.error("Error fetching or parsing URL content: \(fetchError.localizedDescription)")
            return .failure(.fetchError(fetchError))
        }
    }
}
