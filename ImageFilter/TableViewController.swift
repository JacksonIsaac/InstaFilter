//
//  TableViewController.swift
//  ImageFilter
//
//  Created by Jackson Isaac on 08/11/16.
//  Copyright © 2016 Jackson Isaac. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /*
     * Table View is not set in the beginning as the content may change.
     * Its data need to be able to reload and seperate from its presentation.
     * Delegate: Delegate actions to the table. (handle actions and UI controls)
     * Data Source: Delegate control of the data to the table. (provide data)
     * Protocols are added for Delegate
     */
    @IBOutlet var tableView: UITableView!
    
    let filters = [
        "Red",
        "Blue",
        "Green",
        "Yellow",
        "Purple",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filters[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        cell.textLabel?.text = filters[indexPath.row]
        
        return cell
    }
}
