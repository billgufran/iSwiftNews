//
//  HomeViewController.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 4/5/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var newsList: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadNews()
    }
    
    func loadNews() {
        ApiService.shared.loadNews { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let newsList):
                //@todo remove print
                print(newsList)
                self.newsList = newsList
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
