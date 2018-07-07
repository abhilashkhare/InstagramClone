//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Abhilash Khare on 6/18/18.
//  Copyright © 2018 Abhilash Khare. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath)
        return cell
    }


    @IBAction func logOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch {
            print("Logout error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
//    func loadPosts(){
//        Database.database().reference().child("posts").observe(.childAdded) { (dataSnapShot) in
//            print(dataSnapShot.value)
//        }
//    }
}

