//
//  ViewController.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/25/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UIElements
    private lazy var collectionView: UICollectionView = {
        
        let sectionInsetTopAndBottomSpacing = minimumLineSpacing
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: sectionInsetTopAndBottomSpacing, left: 0, bottom: sectionInsetTopAndBottomSpacing, right: 0)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: cellID)
        
        return collectionView
    }()
    
    private lazy var networkSpinner: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView.createActivityIndicatorView()
        return activityIndicatorView
    }()
    
    // MARK: - Ivars
    private var datasource = [Card]()
    
    private let cellID = "cardCellID"
    
    private let minimumLineSpacing: CGFloat = 25
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Deck of Cards"
        
        setupUILayout()
        
        fetchAPI()
    }
}

// MARK: - Fetch API
extension ViewController {
    
    private func fetchAPI() {
        
        let apiStr = "https://deckofcardsapi.com/api/deck/new/draw/?count=52"
        guard let url = URL(string: apiStr) else {
            showAlert(title: "Invalid URL", message: "Please check the URL and try again")
            return
        }
        
        networkSpinner.startAnimating()
        
        NetworkManager.fetchAPIObject(with: url) { (result) in

            DispatchQueue.main.async { [weak self] in
                
                self?.networkSpinner.stopAnimating()
                
                self?.getFetched(result)
            }
        }
    }
}

// MARK: - Get Fetched Result
extension ViewController {
    
    private func getFetched(_ result: Result<[Card], URLSessionError>) {
        
        switch result {
        
        case .failure(let error):
            
            switch error {
            
            case .failedIssue, .responseStatusCodeIssue, .dataIsNil:
                
                showAlert(title: "Something went Awry", message: error.localizedDescription)
                
            case .catchIssue:
                
                showAlert(title: "Error", message: "Data is malformed")
            }
        
        case .success(let cards):
        
            populateDatasource(with: cards)
        }
    }
    
    private func populateDatasource(with cards: [Card]) {
        
        if cards.isEmpty {
            showAlert(title: nil, message: "There aren't any cards to show.\n\nPlease try again later.")
            return
        }
        
        datasource.append(contentsOf: cards)
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CardCell
        
        cell.card = datasource[indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width
        let cellHeight: CGFloat = 80
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UILayout
extension ViewController {
    
    private func setupUILayout() {
        
        view.addSubview(collectionView)
        view.addSubview(networkSpinner)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        networkSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        networkSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
