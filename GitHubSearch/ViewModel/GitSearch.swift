//
//  GitSearch.swift
//  GitHubSearch
//
//  Created by Mary on 29.11.2020.
//

import Foundation
import Alamofire

let resultsTable: GitResults = GitResults()

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


