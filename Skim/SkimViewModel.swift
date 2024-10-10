//
//  SkimViewModel.swift
//  Skim
//
//  Created by Pedro Henriques on 07/10/2024.
//

import SwiftUI
import SwiftSoup

class SkimViewModel: ObservableObject {
    @Published var wpm: Double = 750.0
    let minWpm = 0
    let maxWpm = 1500
    @Published var isShowingReadingView = false
    let getTextFromUrl: (String) -> (String, String)
    
    // Change the initializer to accept a closure for URL extraction
    init(getTextFromUrl: @escaping (String) -> (String, String) = URLTextExtractor.getTextFromUrl) {
        self.getTextFromUrl = getTextFromUrl
    }
    
    func whatToPrint(isUrl: Bool, sentence: String) {
        let contentAndTitle: (title: String, body: String)
        
        if isUrl {
            contentAndTitle = getTextFromUrl(urlToRead: pasteText() ?? "Error pasting")
        } else {
            contentAndTitle = ("Pasted Text", pasteText() ?? "Error")
        }
        
        let (title, body) = contentAndTitle
        
        let newArticle = Article(title: title, body: body)
        var articles = FileStorageManager.shared.loadArticles()
        articles.append(newArticle)
        FileStorageManager.shared.saveArticles(articles)
        
        readString(sentence: body)
    }
    
    func readString(sentence: String) {
        let words = sentence.components(separatedBy: " ")
        var i = 0
        _ = Timer.scheduledTimer(withTimeInterval: wpmSpeed(), repeats: true) { t in
            print(words[i])
            i += 1
            if i >= words.count {
                t.invalidate()
            }
        }
    }
    
    func wpmSpeed() -> Double {
        return 1 / (wpm / 60)
    }

    func pasteText() -> String? {
        weak var pb: UIPasteboard? = .general
        guard let text = pb?.string else { return nil }
        return text.replacingOccurrences(of: "[\\n\\s]+", with: " ", options: .regularExpression)
    }
    
    func isUrl(text: String) -> Bool {
        return text.hasPrefix("http") || text.hasPrefix("www")
    }

    func getTextFromUrl(urlToRead: String) -> (String, String) {
//        if let url = URL(string: urlToRead) {
//            do {
//                let contentOfURL = try String(contentsOf: url)
//                let doc: Document = try SwiftSoup.parse(contentOfURL)
//                
//                let title = try doc.select("h1, h2").first()?.text() ?? "No Title Found"
//                let bodyText = try doc.text()
//                
//                return (title, bodyText)
//            } catch {
//                print("Error: \(error)")
//                return ("Error", "Error: \(error)")
//            }
//        } else {
//            print("Invalid URL")
//            return ("Invalid URL", "Error: Invalid URL")
//        }
        return URLTextExtractor.getTextFromUrl(urlToRead: urlToRead)
    }
}
