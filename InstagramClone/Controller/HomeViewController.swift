//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Abhilash Khare on 6/18/18.
//  Copyright © 2018 Abhilash Khare. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    @IBAction func logOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch {
            print("Logout error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
