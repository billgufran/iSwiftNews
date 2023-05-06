//
//  CoreDataStorage.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 6/5/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorage {
    static let shared: CoreDataStorage = CoreDataStorage()
    private init() {
         printCoreDataDBPath()
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // news from `https://api.lil.software/news` has no unique ID, thus we use news url as an identifier, assuming each url is most likely unique
    private let identifierKey = "url"
    
    func addToReadingList(news: News) {
        let newsData: NewsData
        
        let fetchRequest = NewsData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "\(identifierKey) = '\(news.url)'")
        
        if let data = try? context.fetch(fetchRequest).first {
            newsData = data
        } else {
            newsData = NewsData(context: context)
        }
        
        newsData.url = news.url
        newsData.title = news.title
        newsData.source = news.source
        newsData.publishedDate = news.publishedDate
        newsData.imageUrl = news.imageUrl
        newsData.newsDescription = news.description
        newsData.author = news.author
        newsData.addedAt = Date()
        
        NotificationCenter.default.post(name: .addReadingList, object: nil)
        
        try? context.save()
    }
    
    func getReadingList() -> [News] {
        let fetchRequest = NewsData.fetchRequest()
        let data = (try? context.fetch(fetchRequest)) ?? []
        
        let sortedData = data.sorted { news0, news1 in
            if let date0 = news0.addedAt, let date1 = news1.addedAt {
                return date0 > date1
            } else {
                return false
            }
        }
        
        let newsList = sortedData.compactMap { $0.dto }
        return newsList
    }
    
    func deleteFromReadingList(id: String) {
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(identifierKey) = '\(id)'")
        
        if let data = try? context.fetch(fetchRequest).first {
            context.delete(data)
            
            NotificationCenter.default.post(name: .deleteReadingList, object: nil)
            
            try? context.save()
        }
    }
    
    func isAddedToReadingList(id: String) -> Bool {
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(identifierKey) = '\(id)'")
        
        if (try? context.fetch(fetchRequest).first) != nil {
            return true
        } else {
            return false
        }
    }
    
    func printCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

         print("Core Data DB Path :: \(path ?? "Not found")")
    }
}

extension NewsData {
    var dto: News {
        let news = News(
            author: self.author ?? "",
            url: self.url ?? "",
            source: self.source ?? "",
            title: self.title ?? "",
            description: self.newsDescription ?? "",
            imageUrl: self.imageUrl ?? "",
            publishedDate: self.publishedDate ?? ""
        )
        return news
    }
}
