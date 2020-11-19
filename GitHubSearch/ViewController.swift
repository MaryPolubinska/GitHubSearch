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
   
    var repos1 = [GitResponse]()
    var repos2 = [GitResponse]()
    
      /*  var rsp = [String]() {
            didSet {
             print("TTT \(rsp)")
            }
        }
    */
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTable: UITableView!
    
    let requestQueue1 = DispatchQueue(label: "queue1", qos: .background)
    let requestQueue2 = DispatchQueue(label: "queue2", qos: .background)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func gitReposSearch(text: String, page: Int, completion: @escaping ([GitResponse]) -> Void) {
        let url = "https://api.github.com/search/repositories?page=\(page)&per_page=15&q=" + "\(text)" + "&sort=stars&order=desc"
      AF.request(url).responseDecodable(of: GitResponses.self) { response in
          guard let items = response.value else {
            return completion([])
          }
         print("Got items are: \(items)")
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
                                print(rsp is NSArray)
                            }
                        case .failure(let error):
                            print("Error!!! \(error)")
                        }
        })
    }
    */
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Repos count is \(repos1.count) + \(repos2.count)")
        return repos1.count + repos2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell")
       let repos = repos1 + repos2
        cell?.textLabel?.text = repos[indexPath.row].fullName
        return cell!
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        for i in 1...2 {
            gitReposSearch(text: "", page: i) { repos in
                self.repos1 = repos
                self.repos2 = repos
                  self.searchTable.reloadData()
              }
        }
      
        print("Cancell: clear results")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search was initiated")
        let q = searchBar.text ?? ""
            requestQueue1.async {
                self.gitReposSearch(text: q, page: 1) { repos1 in
                  self.repos1 = repos1
                    self.searchTable.reloadData()
                }
            }
        requestQueue2.async {
            self.gitReposSearch(text: q, page: 2) { repos2 in
              self.repos2 = repos2
                self.searchTable.reloadData()
            }
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
