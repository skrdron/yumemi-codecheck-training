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
    
    var repositories: [[String: Any]]=[]
    var task: URLSessionTask?
    var searchWord: String?
    var url: String?
    var selectedRrepositoryIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchBar.text = "GitHubのリポジトリを検索できるよー"
        SearchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text, !searchWord.isEmpty else {
               return
           }
        self.searchWord = searchWord
        
        url = "https://api.github.com/search/repositories?q=\(searchWord)"
        guard let url = URL(string: self.url ?? "") else {
            print("無効なURL")
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, res, err in
                 guard let data = data else {
                     print("無効なデータ")
                     return
                 }
                 do {
                     if let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let items = obj["items"] as? [[String: Any]] {
                         self?.repositories = items
                         DispatchQueue.main.async {
                             self?.tableView.reloadData()
                         }
                     }
                 } catch {
                    print("JSON解析エラー")
                 }
             }
             task?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail", let destination = segue.destination as? RepositoryDetailViewController{
            destination.searchRepositoryController = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRrepositoryIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
