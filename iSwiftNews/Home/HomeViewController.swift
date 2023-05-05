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
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "news_cell")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsTableViewCell
        
        let news = newsList[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = self.concatLabels([news.date, news.source])
        
        if news.imageUrl != "" {
            cell.thumbImage.sd_setImage(with: URL(string: news.imageUrl))
        } else {
            cell.thumbImage.image = nil
        }
        
        return cell
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
