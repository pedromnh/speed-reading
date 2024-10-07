//
//  ArticleListViewModel.swift
//  Skim
//
//  Created by Pedro Henriques on 07/10/2024.
//

import SwiftUI

class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var wpm: Double = 300
    @Published var isShowingSettings = false
    @StateObject var viewModel = SkimViewModel()

    init() {
        loadArticles()
    }

    func loadArticles() {
        articles = FileStorageManager.shared.loadArticles()
    }

    func saveArticle(from url: String) {
        let (title, body) = viewModel.getTextFromUrl(urlToRead: url)
        let newArticle = Article(title: title, body: body)
        articles.append(newArticle)
        FileStorageManager.shared.saveArticles(articles)
    }

    func deleteArticle(_ article: Article) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles.remove(at: index)
            FileStorageManager.shared.saveArticles(articles)
        }
    }

    func estimatedReadingTime(for body: String) -> String {
        let wordCount = body.split { $0.isWhitespace || $0.isNewline }.count
        let totalSeconds = Int(Double(wordCount) / (wpm / 60.0))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d min %02d sec", minutes, seconds)
    }
}
