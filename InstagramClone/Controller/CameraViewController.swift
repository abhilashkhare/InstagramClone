//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Abhilash Khare on 6/18/18.
//  Copyright © 2018 Abhilash Khare. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var photo : UIImageView!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    
    var selectedImage : UIImage!
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(tapGestureRecognizer:)))
        imagePicker.delegate = self
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handlePost()
    }
    
    func handlePost(){
        if selectedImage != nil{
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
        
    }
    @IBAction func postTouch(_ sender: Any) {
        print("pressed")
        if let profileImage = self.selectedImage ,let photoData = UIImageJPEGRepresentation(profileImage, 0.1){
            print("INSIDE")
            let photoIDString = NSUUID().uuidString
            let imagePath =  photoIDString + "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let storageRef = Storage.storage().reference(forURL : "gs://instagramclone-1eb2f.appspot.com")
        //Convert Image to Firebase friendly JPEG format
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
    
            storageRef.child(imagePath).putData(photoData, metadata: metaData, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                let photoUrl = storageRef.child(metaData.path!).description
                // Create reference to the DB location
                self.sendDatatoDatabase(photoURL: photoUrl)
                
            })
        }
        else{
            print("Please choose an image to upload")
        }
        
    }
    
    func sendDatatoDatabase(photoURL  : String){
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        let newPostID = postReference.childByAutoId().key
        let newPostReference = postReference.child(newPostID)
        newPostReference.setValue(["photoURL":photoURL,"caption" : captionTextView.text.description]) { (error, databaseReference) in
            if error != nil {
                print("Error posting\(error?.localizedDescription)")
            } else {
                print("Posted successfully")
                self.photo.image = UIImage(named: "profile-placeholder")
                self.captionTextView.text = " "
                self.tabBarController?.selectedIndex = 0
            }
        }
        ()
        print("New User reference description\(newPostReference.description())")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let postSelected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.image = postSelected
            selectedImage = postSelected
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
