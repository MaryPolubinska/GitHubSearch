//
//  GitSearch.swift
//  GitHubSearch
//
//  Created by Mary on 29.11.2020.
//

import Foundation
import Alamofire

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

///Some tries to parse data with json

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
