//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Mary Polubinska on 18.11.2020

//Perform a search for GitHub repositories, show 30 results. Search is done in 2 background threads with 15 results in each thread. Ordered by stars, desc.

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!

    let requestQueue1 = DispatchQueue(label: "queue1", qos: .background)
    let requestQueue2 = DispatchQueue(label: "queue2", qos: .background)
    let resultsTable: GitResults = GitResults()

    override func viewWillAppear(_ animated: Bool) {
        searchTable.dataSource = resultsTable
        searchTable.delegate = resultsTable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        for i in 1...2 {
            gitReposSearch(text: "", page: i) { repos in
                repos1 = repos
                repos2 = repos
                  self.searchTable.reloadData()
              }
        }
      
        print("Cancell: clear results")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search was initiated")
        let q = searchBar.text ?? ""
            requestQueue1.async {
                gitReposSearch(text: q, page: 1) { rep1 in
                  repos1 = rep1
                    self.searchTable.reloadData()
                }
            }
        requestQueue2.async {
            gitReposSearch(text: q, page: 2) { rep2 in
              repos2 = rep2
                self.searchTable.reloadData()
            }
        }
    }
}


