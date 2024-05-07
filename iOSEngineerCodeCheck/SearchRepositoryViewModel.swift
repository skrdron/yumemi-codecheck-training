//
//  SearchRepositoryViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 櫻田龍之助 on 2024/05/02.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation
//データの処理と変換を行う

class SearchRepositoryViewModel {
    var repositories: [Repository] = []
    private var task: URLSessionTask?
    
    var onRepositoriesUpdated: (() -> Void)?

    func searchRepositories(searchWord: String) {
        let url = "https://api.github.com/search/repositories?q=\(searchWord)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] data, res, err in
            guard let data = data, let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let items = obj["items"] as? [[String: Any]] else {
                return
            }
            self?.repositories = items.map {
                Repository(
                    fullName: $0["full_name"] as? String ?? "",
                    language: $0["language"] as? String ?? "",
                    starsCount: $0["stargazers_count"] as? Int ?? 0,
                    watchersCount: $0["watchers_count"] as? Int ?? 0,
                    forksCount: $0["forks_count"] as? Int ?? 0,
                    openIssuesCount: $0["open_issues_count"] as? Int ?? 0,
                    avatarURL: ($0["owner"] as? [String: Any])?["avatar_url"] as? String ?? ""
                )
            }
            DispatchQueue.main.async {
                self?.onRepositoriesUpdated?()
            }
        }
        task?.resume()
    }
}

