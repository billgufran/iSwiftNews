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
    
    weak var collectionView: UICollectionView?
    weak var pageControl: UIPageControl?
    
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
        
        // observe for when an item in reading list is removed
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.readingListItemDeleted(_:)),
            name: .deleteReadingList,
            object: nil
        )
    }
    
    @objc func readingListItemDeleted(_ sender: Any) {
        // reloading data so the bookmark button state is updated
        tableView.reloadData()
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
            
            let newsCount = newsList.prefix(5).count
            
            // assign TopNewsTableViewCellDelegate
            cell.delegate = self
            
            cell.subtitleLabel.text = "Top \(newsCount) News of the day"
            
            self.pageControl = cell.pageControl
            cell.pageControl.numberOfPages = newsCount
            
            self.collectionView = cell.collectionView
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsTableViewCell
            
            let isInReadingList = CoreDataStorage
                .shared
                .isAddedToReadingList(id: news.url)
            
            // assign NewsTableViewCellDelegate
            cell.delegate = self
            
            cell.titleLabel.text = news.title
            cell.subtitleLabel.concatLabelsToText([news.publishedDate, news.source])
            
            if isInReadingList {
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(
                        UIImage(systemName: "bookmark.fill"),
                        for: .normal
                    )
                } else {
                    // @todo handle fallback on earlier versions
                }
                cell.bookmarkButton.isEnabled = false
            } else {
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(
                        UIImage(systemName: "bookmark"),
                        for: .normal
                    )
                } else {
                    // @todo handle fallback on earlier versions
                }
                cell.bookmarkButton.isEnabled = true
            }
            
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
        // @todo find out how to disable if tableView is TopNewsTableViewCell, not by section number
        if indexPath.section == 0 {
            return
        }
        
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
        cell.subtitleLabel.concatLabelsToText([news.publishedDate, news.source])
        
        if news.imageUrl != "" {
            cell.thumbImage.sd_setImage(with: URL(string: news.imageUrl))
        } else {
            cell.thumbImage.image = nil
        }
        
        return cell
    }
    
    
}

// MARK: -- UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 256)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let news = newsList[indexPath.item]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl?.currentPage = page
        }
    }
}

// MARK: - TopNewsTableViewCellDelegate
extension HomeViewController: TopNewsTableViewCellDelegate {
    func pageControlValueChanged(_ cell: TopNewsTableViewCell) {
        let page = cell.pageControl.currentPage
        collectionView?.scrollToItem(
            at: IndexPath(item: page, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
}

// MARK: - NewsTableViewCellDelegate
extension HomeViewController: NewsTableViewCellDelegate {
    func cellBookmarkButtonTapped(_ cell: NewsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let news = newsList[indexPath.row]
            
            CoreDataStorage.shared.addToReadingList(news: news)
            
            if #available(iOS 13.0, *) {
                cell.bookmarkButton.setImage(
                    UIImage(systemName: "bookmark.fill"), for: .normal
                )
            } else {
                //@todo handle fallback on earlier versions
            }
            
            cell.bookmarkButton.isEnabled = false
        }
    }
}
