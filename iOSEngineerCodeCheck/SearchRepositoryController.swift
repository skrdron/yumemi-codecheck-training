//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoryController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var SearchBar: UISearchBar!
    
    var viewModel = SearchRepositoryViewModel()
    
    override func viewDidLoad() {
       //継承したUITableViewControllerのviewDidLoad()メソッドを呼び出し、基本的なビューのセットアップを行う
       super.viewDidLoad()
       //クラス自身をSearchBarのデリゲートに設定
       SearchBar.text = "GitHubのリポジトリを検索できるよー"
       SearchBar.delegate = self
       //ビューモデル内でリポジトリのデータが更新された際に呼び出されるクロージャを定義
       viewModel.onRepositoriesUpdated = {
         DispatchQueue.main.async {
           self.tableView.reloadData()
         }
       }
       //テーブルビューのセル登録 : identifierからやってもうまくいかなかった
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RepositoryCell")
    }

    //テーブルビューの行が選択された時の処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    //検索バーの編集が始まる前の処理
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        //編集を許可するためにtrueを返す
        return true
    }
        
    //検索バーで検索ボタンが押された時の処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        //リクエストをビューモデルに送信
        viewModel.searchRepositories(searchWord: searchText)
    }

    //テーブルビューのセクション数を定義
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //テーブルビューの行数を定義
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    //テーブルビューのセルを構成
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        let repository = viewModel.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        return cell
    }

    //セグエを準備する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let destination = segue.destination as? RepositoryDetailViewController,
            let selectedIndex = tableView.indexPathForSelectedRow?.row {
            destination.viewModel = RepositoryDetailViewModel(repository: viewModel.repositories[selectedIndex])
        }
    }
}
