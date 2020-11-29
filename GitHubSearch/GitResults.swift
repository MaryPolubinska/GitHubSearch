//
//  GitResults.swift
//  GitHubSearch
//
//  Created by Mary on 29.11.2020.
//

import Foundation
import  UIKit

class GitResults: NSObject, UITableViewDataSource, UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  repos1.count + repos2.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell")
        let repos = repos1 + repos2
        cell?.textLabel?.text = repos[indexPath.row].fullName
        return cell!
    }

}
