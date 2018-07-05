//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Abhilash Khare on 6/11/18.
//  Copyright © 2018 Abhilash Khare. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
        handleTextFields()
    }
    
    @objc func handleTextFields(){
        email.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        password.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
    }
    
    @objc  func textFieldDidChange(textField : UITextField){
        guard  let  emailText = email.text,!emailText.isEmpty, let passwordText = password.text, !passwordText.isEmpty else {
            signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signInButton.isEnabled = false
            return
        }
        signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
    
    @IBAction func clickSignInButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (authDataResult, error) in
            if(error != nil){
                print("Authentication issue - \(error?.localizedDescription)")
                let alert = UIAlertController(title: "", message: "Invalid Email/Password. Please enter valid credentials", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            print("User Email - \(authDataResult?.user.email)")
            self.performSegue(withIdentifier: "signInSuccess", sender: nil)
        }
    }    
}
