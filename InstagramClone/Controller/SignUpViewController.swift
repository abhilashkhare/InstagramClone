//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Abhilash Khare on 6/12/18.
//  Copyright © 2018 Abhilash Khare. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var userName: UITextField!    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func signUpTouch(_ sender: Any) {

        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResultData, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            // Create reference to the DB location
            
            let ref = Database.database().reference()
            print(ref.description())
            
            let userReference = ref.child("users")
            let userID = authResultData?.user.uid
            let newUserReference = userReference.child(userID!)
            newUserReference.setValue(["username":self.userName.text,"email" : self.emailTextField.text])
            print("New User reference description\(newUserReference.description())")
            
        }
    }
    @IBAction func dismissOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage, let photoData = UIImageJPEGRepresentation(photo, 0.8){
            profileImage.image = photo
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhoto(tapGestureRecognizer: UITapGestureRecognizer){
        self.present(imagePicker, animated: true, completion: nil)
    }
}
