//
//  ResultDisplayController.swift
//  testSwift
//
//  Created by mac on 2020/12/28.
//

import Foundation
import UIKit
class ResultDisplayController :  UITableViewController,UISearchResultsUpdating{
    var dataStr :String = ""
    
    func updateSearchResults(for searchController: UISearchController) {
        if let inputStr = searchController.searchBar.text {
            dataStr = inputStr
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultDisplayControllerCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultDisplayControllerCell", for: indexPath)
        cell.textLabel?.text = dataStr
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}
