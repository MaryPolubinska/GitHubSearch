//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Mary on 10.11.2020.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var resultsTable: UITableView!
    
    
    let tableHelper: SearchTableViewController = SearchTableViewController()
    let requestQueue1 = DispatchQueue(label: "queue1")
    let requestQueue2 = DispatchQueue(label: "queue2")
    var repos = [String]()
    
    var rsp = [String]() {
        didSet {
            repos = rsp
            print("REPOS ARE::::: \(repos)")
        }
    }
    
    
    override func viewDidLoad() {
        tableHelper.zzz = self
        resultsTable.dataSource = tableHelper
        resultsTable.delegate = tableHelper
        var searchText = searchField.text
        resultsTable.allowsSelection = true
        resultsTable.isScrollEnabled = true
        super.viewDidLoad()
    }
    
    func alamofireResponse() {
        let q = searchField.text!
        let url = "https://api.github.com/search/repositories?q=" + "\(q)" + "&sort=stars&order=desc"

        AF.request(url).responseJSON(completionHandler: { [self] response in
        
            switch response.result {
                        case .success(let JSON):
                            let response = JSON as! NSDictionary
                            let name = response.value(forKey: "items")
                          //  print(name is NSArray)
                         //   print(name)
                            
                            if let array = name as? [[String: Any]] {
                                rsp = array.compactMap { $0["full_name"] as? String }
                            }
                        case .failure(let error):
                            print("Error!!! \(error)")
                        }
        })
    }

    
    @IBAction func doSearch(_ sender: Any) {
        alamofireResponse()
}

    
    
     }
    
    
    
    
    
    

