//
//  URLTextExtractor.swift
//  Skim
//
//  Created by Pedro Henriques on 07/10/2024.
//

import SwiftUI
import SwiftSoup

class URLTextExtractor {
    static func getTextFromUrl(urlToRead: String) -> (String, String) {
        if let url = URL(string: urlToRead) {
            do {
                let contentOfURL = try String(contentsOf: url)
                let doc: Document = try SwiftSoup.parse(contentOfURL)
                
                let title = try doc.select("h1, h2").first()?.text() ?? "No Title Found"
                let bodyText = try doc.text()
                
                return (title, bodyText)
            } catch {
                print("Error: \(error)")
                return ("Error", "Error: \(error)")
            }
        } else {
            print("Invalid URL")
            return ("Invalid URL", "Error: Invalid URL")
        }
    }
    
    
}
