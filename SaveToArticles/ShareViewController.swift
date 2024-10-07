//
//  ShareViewController.swift
//  SaveToArticles
//
//  Created by Pedro Henriques on 07/10/2024.
//

import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedUrl()
    }
    
    private func handleSharedUrl() {
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else { return }

        for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier) { (url, error) in
                    if let url = url as? URL {
                        self.saveArticle(from: url.absoluteString)
                    } else {
                        print("Error: \(error?.localizedDescription ?? "Unable to load URL")")
                    }
                }
            }
        }
    }

    private func saveArticle(from url: String) {
        let (title, body) = URLTextExtractor.getTextFromUrl(urlToRead: url)
        var articles = FileStorageManager.shared.loadArticles()
        
        let newArticle = Article(title: title, body: body)
        articles.append(newArticle)
        FileStorageManager.shared.saveArticles(articles)
        
        // Dismiss share sheet
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
