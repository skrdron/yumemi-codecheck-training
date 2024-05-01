//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    weak var searchRepositoryController: SearchRepositoryController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewController = searchRepositoryController,
              let index = viewController.selectedRrepositoryIndex,
              index < viewController.repositories.count else {
            return
        }
        let repository = viewController.repositories[index]
        
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage(for: repository)
    }
    
    func getImage(for repository: [String: Any]) {
        titleLabel.text = repository["full_name"] as? String
        
        if let owner = repository["owner"] as? [String: Any],
           let imgURL = owner["avatar_url"] as? String,
           let url = URL(string: imgURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, res, err in
                if let data = data, let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = img
                    }
                } else {
                    print("データのロードに失敗しました")
                }
            }.resume()
        }
    }
}
