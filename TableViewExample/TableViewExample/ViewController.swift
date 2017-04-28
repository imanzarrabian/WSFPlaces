//
//  ViewController.swift
//  TableViewExample
//
//  Created by Iman Zarrabian on 26/04/2017.
//  Copyright © 2017 One More Thing Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var receipesTableView: UITableView!
    
    let receipes = ["Boeuf carrotte", "tarte au chocolat", "happy meal", "calamars frits"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        receipesTableView.delegate = self
        receipesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = receipes[indexPath.row]
        cell.detailTextLabel?.text = "indexPath.row : \(indexPath.row)"
        return cell
    }
}

