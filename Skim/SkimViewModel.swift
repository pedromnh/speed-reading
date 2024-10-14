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
    let minWordsPerMinute = 0
    let maxWordsPerMinute = 1500
    let getTextFromUrl: (String) -> Result<Article, URLTextError>
    
    init(getTextFromUrl: @escaping (String) -> Result<Article, URLTextError> = URLTextExtractor.getTextFromUrl) {
        self.getTextFromUrl = getTextFromUrl
    }
    
    func whatToPrint(isUrl: Bool, sentence: String) {
        let contentAndTitle: (title: String, body: String)
        
        if isUrl {
            let result = getTextFromUrl(urlToRead: pasteText() ?? "Error pasting")
            switch result {
            case .success(let article):
                contentAndTitle = (title: article.title, body: article.body)
            case .failure(let error):
                contentAndTitle = (title: "Error", body: error.localizedDescription)
            }
        } else {
            contentAndTitle = (title: "Pasted Text", body: pasteText() ?? "Error")
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

    func getTextFromUrl(urlToRead: String) -> Result<Article, URLTextError> {
        let result = URLTextExtractor.getTextFromUrl(urlToRead: urlToRead)
        
        switch result {
        case .success(let article):
            return .success(Article(title: article.title, body: article.body))
        case .failure(let error):
            switch error {
            case .invalidURL:
                return .failure(.invalidURL)
            case .fetchError(let fetchError):
                return .failure(.fetchError(fetchError))
            case .parseError(let parseError):
                return .failure(.parseError(parseError))
            }
        }
    }
}
