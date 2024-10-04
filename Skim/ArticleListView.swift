//
//  ArticleListView.swift
//  Skim
//
//  Created by Pedro Henriques on 04/10/2024.
//

import SwiftUI

struct ArticleListView: View {
    @State private var articles: [Article] = []
    @State private var wpm: Double = 300
    @State private var isShowingSettings = false

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(articles) { article in
                            NavigationLink(destination: ReadingView(wpm: wpm, articleBody: article.body)) {
                                VStack(alignment: .leading) {
                                    
                                    Text(article.title)
                                        .font(.headline)
                                        .bold()
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                    
                                    Text(article.body)
                                        .lineLimit(3)
                                        .truncationMode(.tail)
                                    
                                    Text("Estimated reading time: \(estimatedReadingTime(for: article.body))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteArticle(article)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                        }
                        .onDelete(perform: deleteArticles)
                    }
                    .navigationTitle("Skim")
                    .navigationBarItems(trailing: settingsButton)
                }
                .onAppear {
                    articles = FileStorageManager.shared.loadArticles()
                }

                floatingButton
            }
            .overlay(
                SettingsPopupView(wpm: $wpm, isShowingSettings: $isShowingSettings)
                    .opacity(isShowingSettings ? 1 : 0)
                    .animation(.easeInOut, value: isShowingSettings)
            )
        }
        .accentColor(colorScheme == .dark ? .white : .black)
    }

    var settingsButton: some View {
        Button(action: {
            isShowingSettings.toggle()
        }) {
            Image(systemName: "gear")
                .font(.title2)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        }
    }

    var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if let pastedText = UIPasteboard.general.string, !pastedText.isEmpty {
                        saveArticle(from: pastedText)
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .padding()
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding()
            }
        }
    }

    // Save the article from a pasted URL
    func saveArticle(from url: String) {
        let (title, body) = getTextFromUrl(urlToRead: url)
        let newArticle = Article(title: title, body: body)
        articles.append(newArticle)
        FileStorageManager.shared.saveArticles(articles)
    }
    
    // Save an article with fixed placeholder data
//    func saveArticle(from url: String) {
//        let title = "fixed title"
//        let body = "fixed body"
//
//        let newArticle = Article(title: title, body: body)
//        articles.append(newArticle)
//
//        FileStorageManager.shared.saveArticles(articles)
//    }
    
    // Calculate estimated reading time
    func estimatedReadingTime(for body: String) -> String {
        let wordCount = body.split { $0.isWhitespace || $0.isNewline }.count
        let totalSeconds = Int(Double(wordCount) / (wpm / 60.0))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d min %02d sec", minutes, seconds)
    }

    // Delete an article via button
    func deleteArticle(_ article: Article) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles.remove(at: index)
            FileStorageManager.shared.saveArticles(articles)
        }
    }

    // Delete an article via swipe
    func deleteArticles(at offsets: IndexSet) {
        articles.remove(atOffsets: offsets)
        FileStorageManager.shared.saveArticles(articles)
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
