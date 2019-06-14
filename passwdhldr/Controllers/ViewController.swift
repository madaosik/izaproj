//
//  ViewController.swift
//  passwdhldr
//
//  Created by Adam Láníček on 09/06/2019.
//  Copyright © 2019 FIT VUT. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class MyViewController: UITableViewController {
    
    var passwords: Results<MyPassword>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem!.title = "Upravit"
        //navigationItem.leftBarButtonItem?.title = "Upravit"
        navigationItem.leftBarButtonItem!.tintColor = .white
        //targetTable.delegate = self
        //targetTable.dataSource = self
        }
}

extension MyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.sharedInstance.getDataFromDB().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let index = Int(indexPath.row)
        let myPassword = DBManager.sharedInstance.getDataFromDB()[index] as MyPassword
        cell.textLabel?.text = myPassword.target
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let passwordToDelete = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as MyPassword
            DBManager.sharedInstance.deleteFromDb(object: passwordToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool)
    {
        super.setEditing(editing,animated:animated)
        if(self.isEditing)
        {
            self.editButtonItem.title = "Hotovo"
        } else
        {
            self.editButtonItem.title = "Upravit"
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "addPassword":
                os_log("Adding a new password.", log: OSLog.default, type: .debug)
            
            case "showPasswordDetail":
                guard let passwordDetailVC = segue.destination as? DetailViewController
                else { fatalError("Unexpected destination: \(segue.destination)")}
            
                guard let selectedPasswordCell = sender as? UITableViewCell
                else { fatalError("Unexpected sender: \(sender)") }
            
                guard let indexPath = tableView.indexPath(for: selectedPasswordCell)
                    else {fatalError("The selected password is not being displayed by the table")}
            
                let selectedPassword = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as MyPassword
                print(selectedPassword.id)
                passwordDetailVC.passwordInstance = selectedPassword
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func unwindToPasswordList(sender: UIStoryboardSegue) {
        if let srcVC = sender.source as? DetailViewController, let password = srcVC.passwordInstance {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                DBManager.sharedInstance.updateData(object: password)
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            }
            else {
                let newIndexPath = IndexPath(row: DBManager.sharedInstance.getDataFromDB().count, section: 0)
                DBManager.sharedInstance.addData(object: password)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}

