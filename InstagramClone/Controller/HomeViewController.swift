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
    var post = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadPosts()
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
    
    func loadPosts(){
        Database.database().reference().child("posts").observe(.childAdded) { (dataSnapShot) in
            print("Snapshot")
           print(dataSnapShot.value)
            var captionTextString = String()
            captionTextString = ""
            if let dict = dataSnapShot.value as? [String : Any]{
                if  let captionText = dict["caption"] as? String {
                    captionTextString = captionText
                }
                
                let photoURL = dict["photoURL"] as! String
                let post = Post(captionText: captionTextString, photoUrlString: photoURL)
                self.post.append(post)
            }
            
            for item in self.post{
                print("Post  \(item) Caption : \(item.caption)  photoURL : \(item.photoURL)" as Any)
            }
        }
    }
}

