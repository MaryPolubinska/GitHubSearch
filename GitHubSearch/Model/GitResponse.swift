//
//  GitResponse.swift
//  GitHubSearch
//
//  Created by Mary on 29.11.2020.
//

import Foundation


var repos1 = [GitResponse]()
var repos2 = [GitResponse]()

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
