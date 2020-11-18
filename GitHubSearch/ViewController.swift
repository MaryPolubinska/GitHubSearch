//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Mary on 18.11.2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
   
        var repos = [GitResponse]()
    
      /*  var rsp = [String]() {
            didSet {
             print("TTT \(rsp)")
            }
        }
      
    */
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func gitReposSearch(text: String, completion: @escaping ([GitResponse]) -> Void) {
        let url = "https://api.github.com/search/repositories?q=" + "\(text)" + "&sort=stars&order=desc"
      AF.request(url).responseDecodable(of: GitResponses.self) { response in
          guard let items = response.value else {
            return completion([])
          }
          completion(items.items)
        }
    }

/*
    func alamofireResponse() {
        let q = searchBar.text ?? ""
        let url = "https://api.github.com/search/repositories?q=" + "\(q)" + "&sort=stars&order=desc"
        AF.request(url).responseJSON(completionHandler: { [self] response in
            switch response.result {
                        case .success(let JSON):
                            let response = JSON as! NSDictionary
                            let name = response.value(forKey: "items")
                            if let array = name as? [[String: Any]] {
                                rsp = array.compactMap { $0["full_name"] as? String }
                                print("RSP ===== \(rsp)")
                            }
                        case .failure(let error):
                            print("Error!!! \(error)")
                        }
        })
    }
    */
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Repos count is \(repos.count)")
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell")
        cell?.textLabel?.text = repos[indexPath.row].fullName
        return cell!
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        print("Cancell")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search")
        let q = searchBar.text ?? ""
        gitReposSearch(text: q) { repos in
          self.repos = repos
            self.searchTable.reloadData()
        }
    }
}

struct GitResponse {
  let fullName: String
  enum Keys: String, CodingKey {
    case fullName = "full_name"
  }
}

struct GitResponses: Decodable {
  let items: [GitResponse]
}

extension GitResponse: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    fullName = try container.decode(String.self, forKey: .fullName)
  }
}
