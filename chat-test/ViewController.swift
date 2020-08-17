//
//  ViewController.swift
//  chat-test
//
//  Created by Gor on 5/17/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var ref = Database.database().reference().child("messages")
    var messages = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
    var observer : Any?
    
    func getMessages() {
        observer = ref.observe(.value, with: { (snapshot) in
            guard let message = snapshot.value as? [String] else { return }
            self.messages = message
        }, withCancel: nil)
    }
    
    func sendMessage(text: String) {
         let reference = Database.database().reference()
         self.messages.append(text)
         reference.child("messages").setValue(self.messages)
     }
    
    @IBAction func addMessage(_ sender: Any) {
        let alert = UIAlertController(title: "Send a message", message: " ", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        let sendAction = UIAlertAction(title: "Send", style: UIAlertAction.Style.cancel){(_) in
            guard let text = alert.textFields?.first?.text else {return}
            self.sendMessage(text: text)
        }
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(sendAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

