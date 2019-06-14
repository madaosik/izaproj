//
//  DetailViewController.swift
//  passwdhldr
//
//  Created by Adam Láníček on 11/06/2019.
//  Copyright © 2019 FIT VUT. All rights reserved.
//

import UIKit
import os.log

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    var passwordInstance: MyPassword?
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var targetText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var remarkText: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddPasswordMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPasswordMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DetailViesController is not inside a navigation controller.")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetText.delegate = self
        
        if let password = passwordInstance {
            print(password.id)
            targetText.text = password.target
            loginText.text = password.login
            passwordText.text = password.passphrase
            emailText.text = password.email
            remarkText.text = password.comment
        }
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = targetText.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if (passwordInstance == nil) {
            passwordInstance = MyPassword()
            passwordInstance?.id = UUID().uuidString
        }
        
        try! DBManager.sharedInstance.database.write {
            passwordInstance?.target = targetText.text ?? "Bez názvu"
            passwordInstance?.login = loginText.text ?? ""
            passwordInstance?.passphrase = passwordText.text ?? ""
            passwordInstance?.email = emailText.text ?? ""
            passwordInstance?.comment = remarkText.text ?? ""
        }

    }
    
    private func updateSaveButtonState() {
        let text = targetText.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
