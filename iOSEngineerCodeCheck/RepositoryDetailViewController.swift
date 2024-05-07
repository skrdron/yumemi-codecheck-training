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
    
    var viewModel: RepositoryDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayRepositoryDetails()
    }
        
    func displayRepositoryDetails() {
        guard let repository = viewModel.repository else {
            return
        }
            
        titleLabel.text = repository.fullName
        languageLabel.text = "Written in \(repository.language)"
        starsLabel.text = "\(repository.starsCount) stars"
        watchersLabel.text = "\(repository.watchersCount) watchers"
        forksLabel.text = "\(repository.forksCount) forks"
        issuesLabel.text = "\(repository.openIssuesCount) open issues"

        // 画像の読み込み
        if let url = URL(string: repository.avatarURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }.resume()
        }
    }
}
