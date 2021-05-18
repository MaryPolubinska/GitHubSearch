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
    let emptyTable: EmptyResults = EmptyResults()

    override func viewWillAppear(_ animated: Bool) {
        searchTable.dataSource = resultsTable
        searchTable.delegate = resultsTable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchTable.dataSource = emptyTable
        self.searchTable.delegate = emptyTable
        self.searchTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTable.dataSource = resultsTable
        searchTable.delegate = resultsTable
        let q = searchBar.text ?? ""
            gitReposResults(text: q)
            
    }
    
    func gitReposResults(text: String) {
        
        requestQueue1.async {
            gitReposSearch(text: text, page: 1) { rep1 in
                repos1 = rep1
                self.searchTable.reloadData()
            }
        }
        requestQueue2.async {
            gitReposSearch(text: text, page: 2) { [self] rep2 in
                repos2 = rep2
                self.searchTable.reloadData()
            }
        }
    }
}


