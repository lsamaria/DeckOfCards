//
//  UIImageView+Extensions.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/24/22.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // MARK: - CreateImageView
    static func createImageView(contentMode: UIView.ContentMode = .scaleAspectFit, cornerRadius: CGFloat = 0) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = contentMode
        imageView.backgroundColor = .black
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        return imageView
    }
}

// MARK: - Fetch Image
extension UIImageView {
    
    func fetchImage(with url: URL, and task: inout URLSessionDataTask?, completion: @escaping (URLSessionError?)->Void) {
        
        image = nil

        if let cachedImage = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {

            completion(nil)

            image = cachedImage
            return
        }
        
        NetworkManager.fetchCellImage(with: url, and: &task) { (result) in
            
            switch result {
            
            case .failure(let err):
                
                completion(err)
                
            case .success(let downloadedImage):
                
                completion(nil)
                
                DispatchQueue.main.async { [weak self] in
                    self?.image = downloadedImage
                }
            }
        }
    }
}
