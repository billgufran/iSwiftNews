//
//  News.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 4/5/23.
//

import Foundation

struct News: Decodable {
    let author: String
    let url: String
    let source: String
    let title: String
    let description: String
    let imageUrl: String
    let publishedDate: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case url
        case source
        case title
        case description
        case image
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.author =  try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.source =  try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.description =  try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        
        if let date = try container.decodeIfPresent(String.self, forKey: .date) {
            self.publishedDate = normalizeDate(date)
        } else {
            self.publishedDate = ""
        }
    }
    
    init(
        author: String,
        url: String,
        source: String,
        title: String,
        description: String,
        imageUrl: String,
        publishedDate: String
    ) {
        self.author = author
        self.url = url
        self.source = source
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.publishedDate = publishedDate
    }
}

func toDate(
    _ dateString: String,
    format dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ"
) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter.date(from: dateString)
}

func toFormattedDateString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.string(from: date)
}

func normalizeDate(_ dateString: String) -> String {
    guard let date = toDate(dateString) else {
        return ""
    }
    
    return toFormattedDateString(date)
}

