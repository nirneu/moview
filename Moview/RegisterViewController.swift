//
//  RegisterViewController.swift
//  Moview
//
//  Created by admin on 03/07/2021.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var selectedImage: UIImage?
    
    @IBAction func registerButton(_ sender: Any) {
        if (!isFormValid()) {
            let alert = UIAlertController(title: "Error", message: "Please choose a profile picture and fill all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            //Auth.auth().createUser(withEmail: emailText.text, password: password) { authResult, error in
              // ...
            //}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set profile image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
        }
        else {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profileImage.image = selectedImage
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func isFormValid() -> Bool {
        var isValid = true
        if (self.fullNameText.text?.isEmpty ?? true) {
            isValid = false
        }
        else if (emailText.text?.isEmpty ?? true) {
            isValid = false
        }
        else if (passwordText.text?.isEmpty ?? true) {
            isValid = false
        }
        else if selectedImage == nil {
            isValid = false
        }
        
        return isValid
    }
}
