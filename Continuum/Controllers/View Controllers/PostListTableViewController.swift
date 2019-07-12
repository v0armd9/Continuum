//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var resultsArray: [Post]?
    
    var isSearching: Bool = false
    
    var dataSource: [Post]? {
        return isSearching ? resultsArray : PostController.sharedInstance.posts
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        performFullSync(completion: nil)
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = 500
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        resultsArray = PostController.sharedInstance.posts
    }
    
    func performFullSync(completion:((Bool) -> Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.sharedInstance.fetchPosts { (posts) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                completion?(posts != nil)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {return 0}
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        if let dataSource = dataSource {
        let post = dataSource[indexPath.row]
        cell.post = post
        cell.updateViews()
        }
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailView" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let dataSource = self.dataSource
                else {return}
            let destinationVC = segue.destination as? PostDetailTableViewController
            let post = dataSource[indexPath.row]
            destinationVC?.post = post
        }
    }
}

extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            resultsArray = PostController.sharedInstance.posts.filter { $0.matches(searchTerm: searchText)}
            tableView.reloadData()
        } else {
            resultsArray = PostController.sharedInstance.posts
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.sharedInstance.posts
        searchBar.text = ""
        tableView.reloadData()
        self.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}
