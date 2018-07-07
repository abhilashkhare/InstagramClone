//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Abhilash Khare on 6/18/18.
//  Copyright © 2018 Abhilash Khare. All rights reserved.
//

import UIKit

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
    @IBAction func postTouch(_ sender: Any) {
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
