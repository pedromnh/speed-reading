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
    
    private func getDocumentsDirectory() -> URL {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.pedromnh.skim")!
        
        let documentsDirectory = sharedContainer.appendingPathComponent("Documents")
        if !FileManager.default.fileExists(atPath: documentsDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating documents directory: \(error.localizedDescription)")
            }
        }
        return documentsDirectory
    }
    
    func saveArticles(_ articles: [Article]) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            let data = try JSONEncoder().encode(articles)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print("Articles saved successfully at \(fileURL.path)")
        } catch {
            print("Error saving articles: \(error.localizedDescription)")
        }
    }

    func loadArticles() -> [Article] {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            print("File does not exist, creating empty articles.json")
            saveArticles([])
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let articles = try JSONDecoder().decode([Article].self, from: data)
            return articles
        } catch {
            print("Error loading articles: \(error.localizedDescription)")
            return []
        }
    }
}
