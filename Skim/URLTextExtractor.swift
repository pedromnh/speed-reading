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
    
    static func getTextFromUrl(urlToRead: String) async -> Result<Article, URLTextError> {
        guard let url = URL(string: urlToRead) else {
            Logger.urlProcessing.error("Invalid URL: \(urlToRead)")
            return .failure(.invalidURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.urlProcessing.error("Invalid response or status code.")
                return .failure(.invalidResponse)
            }
            
            guard let contentOfURL = String(data: data, encoding: .utf8) else {
                Logger.urlProcessing.error("Failed to convert data to string.")
                return .failure(.dataConversionFailed)
            }
            
            let doc: Document = try SwiftSoup.parse(contentOfURL)
            let contentElements = try doc.select("article, .main-content, .post, .entry-content, .content")
            
            let bodyText = try contentElements.map { element in
                try element.text()
            }.joined(separator: "\n\n")
            
            let title = try doc.select("title, h1, h2").first()?.text() ?? "No Title Found"
            
            Logger.urlProcessing.info("Successfully fetched content from URL: \(urlToRead)")
            
            let article = Article(title: title, body: bodyText)
            return .success(article)
            
        } catch let fetchError as NSError {
            Logger.urlProcessing.error("Error fetching or parsing URL content: \(fetchError.localizedDescription)")
            return .failure(.fetchError(fetchError))
        }
    }
}
