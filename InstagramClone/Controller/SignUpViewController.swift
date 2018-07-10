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
import FirebaseStorage

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var userName: UITextField!    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    var selectedImage : UIImage!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        signUpButton.isEnabled = false
        handleTextFields()
    }
      @objc func handleTextFields(){
        userName.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

    }
    
    @objc  func textFieldDidChange(textField : UITextField){
        guard  let userNameText = userName.text,!userNameText.isEmpty , let email = emailTextField.text,!email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    

    fileprivate func configDatabase(_ profileImageUrl: String? , _ userID : String) {
        // Create reference to the DB location
        
        let ref = Database.database().reference()
        let userReference = ref.child("users")
        let newUserReference = userReference.child(userID)
        newUserReference.setValue(["username":self.userName.text,"email" : self.emailTextField.text,"profileImageURL": profileImageUrl])
        print("New User reference description\(newUserReference.description())")
    }
    
    @IBAction func signUpTouch(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResultData, error) in
            if error != nil {
                print("USER CREATION ERROR \(error?.localizedDescription)")
                print("Authentication issue - \(error?.localizedDescription)")
                let alert = UIAlertController(title: "", message: "Could not create new user.Please try again with different username/email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else{
            if let userID = authResultData?.user.uid{

                let storageRef = Storage.storage().reference(forURL : "gs://instagramclone-1eb2f.appspot.com").child("profile_image").child(userID)
            //Convert Image to Firebase friendly JPEG format
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            if let profileImage = self.selectedImage ,let photoData = UIImageJPEGRepresentation(profileImage, 0.1){
                storageRef.putData(photoData, metadata: metaData, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImageUrl = metaData.path?.description
                    self.configDatabase(profileImageUrl,userID)
                    self.dismiss(animated: true, completion: nil)

                })
            }
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = photo
            selectedImage = photo
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
