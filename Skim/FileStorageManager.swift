//
//  FileStorageManager.swift
//  Skim
//
//  Created by Pedro Henriques on 04/10/2024.
//

import Foundation

class FileStorageManager {
    static let shared = FileStorageManager()
    
    private let filename = "articles.json"
    
    func saveArticles(_ articles: [Article]) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            let data = try JSONEncoder().encode(articles)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print("Articles saved successfully!")
        } catch {
            print("Error saving articles: \(error.localizedDescription)")
        }
    }

    func loadArticles() -> [Article] {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let articles = try JSONDecoder().decode([Article].self, from: data)
            return articles
        } catch {
            print("Error loading articles: \(error.localizedDescription)")
            return []
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
