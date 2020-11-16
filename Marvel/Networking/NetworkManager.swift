//
//  NetworkManager.swift
//  Marvel
//
//  Created by Albert on 15/11/20.
//

import Foundation
import RxSwift

class NetworkManager {
    
    func getCharacters() -> Observable<[Character]> {
        
        return Observable.create { observer in
            
            let urlSession = URLSession(configuration: .default)
          
            let timestamp = Int(Date().timeIntervalSince1970)
            let hash = "\(timestamp)\(Api.apiKey.privateKey)\(Api.apiKey.publicKey)"
            
            guard let url = URL(string: String(format: "%@%@?%@=%@&hash=%@&ts=%d", Api.url.base, Api.url.characters, Api.apiKey.key, Api.apiKey.publicKey, hash.md5(), timestamp)) else {
                return Disposables.create {
                    urlSession.finishTasksAndInvalidate()
                }
            }
            
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            urlSession.dataTask(with: request) { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse, error == nil, response.statusCode == 200 else { return }
                
                do {
                    let decoder = JSONDecoder()
                
                    let characters = try decoder.decode(CharactersRoot.self, from: data)
                    
                    observer.onNext(characters.data.results)
                    
                } catch let error {
                    observer.onError(error)
                    print(error.localizedDescription)
                }
              
                observer.onCompleted()
                
            }.resume()
            
            return Disposables.create {
                urlSession.finishTasksAndInvalidate()
            }
        }
    }
    
    func getCharacterData(characterId: Int) -> Observable<[CharacterDetail]> {
        
        return Observable.create { observer in
            
            let urlSession = URLSession(configuration: .default)
          
            let timestamp = Int(Date().timeIntervalSince1970)
            let hash = "\(timestamp)\(Api.apiKey.privateKey)\(Api.apiKey.publicKey)"
            
            guard let url = URL(string: String(format: String(format: "%@%@?%@=%@&hash=%@&ts=%d", Api.url.base, Api.url.characterDetail, Api.apiKey.key, Api.apiKey.publicKey, hash.md5(), timestamp), characterId)) else {
                return Disposables.create {
                    urlSession.finishTasksAndInvalidate()
                }
            }
            
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            urlSession.dataTask(with: request) { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse, error == nil, response.statusCode == 200 else { return }
                
                do {
                    let decoder = JSONDecoder()
                
                    let characterDetail = try decoder.decode(CharacterDetailRoot.self, from: data)
                    
                    observer.onNext(characterDetail.data.results)
                    
                } catch let error {
                    observer.onError(error)
                    print(error.localizedDescription)
                }
              
                observer.onCompleted()
                
            }.resume()
            
            return Disposables.create {
                urlSession.finishTasksAndInvalidate()
            }
        }
    }
    
}
