//
//  SavingPopupView.swift
//  SaveToArticles
//
//  Created by Pedro Henriques on 15/11/2024.
//

import UIKit

class SavingPopupView: UIView {
    private let progressIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemGreen
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Saving..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        containerView.addSubview(progressIndicator)
        containerView.addSubview(checkmarkImageView)
        containerView.addSubview(messageLabel)
        
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            progressIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            
            checkmarkImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 45),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 45),
            
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: progressIndicator.bottomAnchor, constant: 16)
        ])
    }
    
    func showCompletion(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.progressIndicator.stopAnimating()
            UIView.animate(withDuration: 0.3, animations: {
                self.progressIndicator.alpha = 0
                self.checkmarkImageView.alpha = 1
                self.messageLabel.text = "Saved!"
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    completion()
                }
            }
        }
    }
}
