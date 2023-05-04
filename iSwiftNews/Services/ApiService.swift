//
//  ApiService.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 4/5/23.
//

import Foundation
import Alamofire

class ApiService {
    
    // create singleton
    static let shared: ApiService = ApiService()
    private init() { }
    
    // initialize constants
    private let BASE_URL = "https://api.lil.software"
    private let NEWS_ENDPOINT = "/news"
    
    // methods
    func loadNews(completion: @escaping (Result<[News], Error>) -> Void) {
        let urlString = "\(BASE_URL)\(NEWS_ENDPOINT)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: NewsResponse.self) { response in
                switch response.result {
                case .success(let newsResponse):
                    completion(.success(newsResponse.articles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
