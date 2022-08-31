//
//  NetworkManager.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/25/22.
//

import UIKit

enum URLSessionError: Error {
    case failedIssue(Error)
    case responseStatusCodeIssue(Int)
    case dataIsNil
    case catchIssue(Error)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
}

// MARK: - Data Fetch
extension NetworkManager {
    
    static func fetchData(with url: URL, completion: @escaping (Result<Data, URLSessionError>)->Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.failedIssue(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard 200 ..< 300 ~= response.statusCode else {
                    completion(.failure(.responseStatusCodeIssue(response.statusCode)))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(.dataIsNil))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
}

// MARK: - Deck Fetch
extension NetworkManager {
    
    static func fetchAPIObject(with url: URL, completion: @escaping (Result<[Card], URLSessionError>)->Void) {
        
        fetchData(with: url) { (result) in
            
            switch result {
            
            case .failure(let err):
                
                print("\nfailed-error: ", err)
                
                completion(.failure(err))
            
            case .success(let data):
                
                do {
                    
                    let deck = try JSONDecoder().decode(Deck.self, from: data)
                    print("\ndeck: ", deck)
                    
                    let cards = deck.cards
                    
                    completion(.success(cards))
                    
                } catch {
                    
                    completion(.failure(.catchIssue(error)))
                    
                    guard let err = error as? DecodingError else {
                        debugPrint("\ndecodingError-:", error)
                        return
                    }
                    
                    switch err {
                    case .typeMismatch(let key, let value):
                        print("\ndecodingError-Mismatch: \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case .valueNotFound(let key, let value):
                        print("\ndecodingError-ValueNotFound: \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case .keyNotFound(let key, let value):
                        print("\ndecodingError-KeyNotFound(: \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case .dataCorrupted(let key):
                        print("\ndecodingError-DataCorrupted: \(key), and ERROR: \(error.localizedDescription)")
                    default:
                        print("\ndecodingError-UnknownError: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

// MARK: - Cell Image Fetch
extension NetworkManager {
    
    static func fetchCellImage(with url: URL, and task: inout URLSessionDataTask?, completion: @escaping (Result<UIImage, URLSessionError>)->Void) {
        
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                completion(.failure(.failedIssue(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard 200 ..< 300 ~= response.statusCode else {
                    completion(.failure(.responseStatusCodeIssue(response.statusCode)))
                    return
                }
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                completion(.failure(.dataIsNil))
                return
            }
            
            imageCache.setObject(downloadedImage, forKey: url.absoluteString as AnyObject)
            
            completion(.success(downloadedImage))
        })
        task?.resume()
    }
}
