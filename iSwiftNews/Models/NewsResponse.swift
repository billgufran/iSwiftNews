//
//  NewsResponse.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 4/5/23.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [News]
    
    enum CodingKeys: String, CodingKey {
        case articles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.articles = try container.decodeIfPresent([News].self, forKey: .articles) ?? []
    }
}
