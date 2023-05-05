//
//  HomeViewController.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 4/5/23.
//

import UIKit
import SDWebImage
import SafariServices

// MARK: - UIViewController
class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var newsList: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(
            UINib(nibName: "NewsTableViewCell", bundle: nil),
            forCellReuseIdentifier: "news_cell"
        )
        tableView.dataSource = self
        tableView.delegate = self
        
        loadNews()
    }
    
    func loadNews() {
        ApiService.shared.loadNews { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let newsList):
                self.newsList = newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - extension UITableView
// MARK: -- UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return newsList.count > 0 ? 1 : 0
        default:
            return newsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = newsList[indexPath.row]
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "top_news_cell", for: indexPath) as! TopNewsTableViewCell
            
            cell.collectionView.dataSource = self
//            cell.collectionView.delegate = self
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsTableViewCell
            
            cell.titleLabel.text = news.title
            cell.subtitleLabel.concatLabelsToText([news.date, news.source])
            
            if news.imageUrl != "" {
                cell.thumbImage.sd_setImage(with: URL(string: news.imageUrl))
            } else {
                cell.thumbImage.image = nil
            }
            
            return cell
        }
    }
}

// MARK: -- UITableViewDataDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - extension UICollectionView
// MARK: -- UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsList.prefix(5).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_collection_cell", for: indexPath) as! TopNewsCollectionViewCell
        
        let news = newsList[indexPath.item]
        
        cell.titleLabel.text = news.title
        cell.subtitleLabel.concatLabelsToText([news.date, news.source])
        
        if news.imageUrl != "" {
            cell.thumbImage.sd_setImage(with: URL(string: news.imageUrl))
        } else {
            cell.thumbImage.image = nil
        }
        
        return cell
    }
    
    
}
