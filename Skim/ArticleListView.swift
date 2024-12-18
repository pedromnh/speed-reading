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
                    .refreshable {
                        viewModel.loadArticles()
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
                if viewModel.isShowingAddArticlePopup {
                    addArticlePopup
                }
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
                    viewModel.isShowingAddArticlePopup = true
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

    var addArticlePopup: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Text("Add New Article")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Title", text: $viewModel.newArticleTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Body", text: $viewModel.newArticleBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(height: 100, alignment: .top)
                
                HStack {
                    Button("Cancel") {
                        viewModel.isShowingAddArticlePopup = false
                    }
                    .padding()
                    
                    Button("Save") {
                        viewModel.saveNewArticle()
                    }
                    .padding().colorInvert()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(.horizontal, 40)
        }
    }
}
