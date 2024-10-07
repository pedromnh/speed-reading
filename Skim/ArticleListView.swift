//
//  ArticleListView.swift
//  Skim
//
//  Created by Pedro Henriques on 04/10/2024.
//

import SwiftUI

struct ArticleListView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = ArticleListViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: ReadingView(articleBody: article.body, wpm: viewModel.wpm)) {
                                VStack(alignment: .leading) {
                                    Text(article.title)
                                        .font(.headline)
                                        .bold()
                                        .lineLimit(2)
                                        .truncationMode(.tail)

                                    Text(article.body)
                                        .lineLimit(3)
                                        .truncationMode(.tail)

                                    Text("Estimated reading time: \(viewModel.estimatedReadingTime(for: article.body))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteArticle(article)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { viewModel.deleteArticle(viewModel.articles[$0]) }
                        }
                    }
                    .navigationTitle("Skim")
                    .navigationBarItems(trailing: settingsButton)
                }
                .overlay(
                    SettingsView(wpm: $viewModel.wpm, isShowingSettings: $viewModel.isShowingSettings)
                        .opacity(viewModel.isShowingSettings ? 1 : 0)
                        .animation(.easeInOut, value: viewModel.isShowingSettings)
                )

                floatingButton
            }
        }
        .tint(colorScheme == .dark ? .white : .black)
    }

    var settingsButton: some View {
        Button(action: {
            viewModel.isShowingSettings.toggle()
        }) {
            Image(systemName: "gear")
                .font(.title2)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }

    var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if let pastedText = UIPasteboard.general.string, !pastedText.isEmpty {
                        viewModel.saveArticle(from: pastedText)
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
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
