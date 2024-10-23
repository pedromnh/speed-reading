//
//  ShareViewController.swift
//  SaveToArticles
//
//  Created by Pedro Henriques on 07/10/2024.
//

import UIKit
import UniformTypeIdentifiers
import OSLog

class ShareViewController: UIViewController {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ShareExtension")

    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedUrl()
    }
    
    private func handleSharedUrl() {
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else {
            logger.error("No input items or attachments found.")
            return
        }

        for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier) { (url, error) in
                    if let url = url as? URL {
                        self.logger.info("Shared URL received: \(url.absoluteString)")
                        
                        Task {
                            await self.saveArticle(from: url.absoluteString)
                        }
                        
                    } else {
                        self.logger.error("Error loading URL: \(error?.localizedDescription ?? "Unable to load URL")")
                    }
                }
            } else {
                logger.error("Attachment does not conform to URL type.")
            }
        }
    }

    private func saveArticle(from url: String) async {
        let result = await URLTextExtractor.getTextFromUrl(urlToRead: url)

        switch result {
        case .success(let article):
            var articles = FileStorageManager.shared.loadArticles()
            articles.append(article)
            FileStorageManager.shared.saveArticles(articles)

            logger.info("Article saved successfully: \(article.title)")
            
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)

        case .failure(let error):
            switch error {
            case .invalidURL:
                logger.error("Invalid URL: \(url)")
            case .fetchError(let fetchError):
                logger.error("Fetch Error: \(fetchError.localizedDescription)")
            case .parseError(let parseError):
                logger.error("Parse Error: \(parseError.localizedDescription)")
            case .invalidResponse:
                logger.error("Invalid Response")
            case .dataConversionFailed:
                logger.error("Data Conversion Failed")
            }
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
}
