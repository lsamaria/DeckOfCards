//
//  CardCell.swift
//  RandomCards
//
//  Created by LanceMacBookPro on 8/24/22.
//

import UIKit

final class CardCell: UICollectionViewCell {
    
    // MARK: - UIElements
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView.createImageView(cornerRadius: 7)
        return imageView
    }()
    
    private lazy var networkSpinner: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView.createActivityIndicatorView(color: .white)
        return activityIndicatorView
    }()
    
    private lazy var suitLabel: UILabel = {
        let label = UILabel.createUILabel(textAlignment: .left, font: UIFont.systemFont(ofSize: 17))
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel.createUILabel(textAlignment: .left, font: UIFont.systemFont(ofSize: 17))
        return label
    }()
    
    // MARK: - Ivars
    public var card: Card? {
        didSet {
            
            guard let card = card else { return }
            
            setImageView(for: card)
            
            setSuitLabel(for: card)
            
            setValueLabel(for: card)
            
            setupUILayout()
        }
    }
    
    private var task: URLSessionDataTask?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancelTask()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init(coder:) has not been implemented")
    }
}

// MARK: - Cancel Task
extension CardCell {
    
    private func cancelTask() {
        
        task?.cancel()
        task = nil
        cardImageView.image = nil
    }
}

// MARK: - Set Data
extension CardCell {
    
    private func setImageView(for card: Card) {
        
        guard let imageUrlStr = card.image, let url = URL(string: imageUrlStr) else { return }
        
        networkSpinner.startAnimating()
        
        cardImageView.fetchImage(with: url, and: &task) { (urlSessionError) in
            
            DispatchQueue.main.async { [weak self] in
                self?.networkSpinner.stopAnimating()
            }
            
            if let urlSessionError = urlSessionError {
                print("\nimage-error-for-\(card.suit ?? ""): ",  urlSessionError)
            }
        }
    }
    
    private func setSuitLabel(for card: Card) {
        
        let cardSuit = card.suit ?? "Suit Unavailable"
        
        suitLabel.text = cardSuit.capitalized
    }
    
    private func setValueLabel(for card: Card) {
        
        let cardValue = card.value ?? "Value Unavailable"
        
        valueLabel.text = cardValue.capitalized
    }
}

// MARK: - UILayout
extension CardCell {
    
    private func setupUILayout() {
        
        contentView.addSubview(cardImageView)
        cardImageView.addSubview(networkSpinner)
        contentView.addSubview(suitLabel)
        contentView.addSubview(valueLabel)
        
        let cardImageViewLeadingPadding: CGFloat = 8
        let cardImageViewWidthHeight: CGFloat = 80
        
        cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cardImageViewLeadingPadding).isActive = true
        cardImageView.widthAnchor.constraint(equalToConstant: cardImageViewWidthHeight).isActive = true
        cardImageView.heightAnchor.constraint(equalToConstant: cardImageViewWidthHeight).isActive = true
        
        networkSpinner.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor).isActive = true
        networkSpinner.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor).isActive = true
        
        let suitLabelLeadingPadding: CGFloat = 5
        let suitLabelTrailingPadding: CGFloat = 8
        
        suitLabel.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor).isActive = true
        suitLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: suitLabelLeadingPadding).isActive = true
        suitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -suitLabelTrailingPadding).isActive = true
        
        valueLabel.bottomAnchor.constraint(equalTo: suitLabel.topAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: suitLabel.leadingAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: suitLabel.trailingAnchor).isActive = true
    }
}
