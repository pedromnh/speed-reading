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
    private var savingPopup: SavingPopupView?

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
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier) { [weak self] (url, error) in
                    guard let self = self else { return }
                    
                    if let url = url as? URL {
                        self.logger.info("Shared URL received: \(url.absoluteString)")
                        self.showSavingPopup()

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
            await showCompletionAndDismiss()
        case .failure(let error):
            logger.error("Error saving article: \(error.localizedDescription)")
            await showCompletionAndDismiss()
        }
    }

    private func showSavingPopup() {
        DispatchQueue.main.async {
            let popup = SavingPopupView()
            popup.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(popup)
            
            NSLayoutConstraint.activate([
                popup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                popup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                popup.topAnchor.constraint(equalTo: self.view.topAnchor),
                popup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
            self.savingPopup = popup
        }
    }

    private func showCompletionAndDismiss() async {
        await MainActor.run {
            savingPopup?.showCompletion {
                self.savingPopup?.removeFromSuperview()
                self.savingPopup = nil
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }
}
