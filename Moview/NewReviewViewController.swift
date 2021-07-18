//
//  NewReviewViewController.swift
//  Moview
//
//  Created by admin on 13/07/2021.
//

import UIKit
import FirebaseAuth

class NewReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var movieName: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var rating: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var selectedImageVar: UIImage?
    
    var data = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.stopAnimating()
        
        // Set profile image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        selectedImage.isUserInteractionEnabled = true
        selectedImage.addGestureRecognizer(tapGestureRecognizer)
        
        reviewText!.layer.borderWidth = 0.5
        reviewText!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        reviewText!.layer.cornerRadius = 5
        reviewText!.clipsToBounds = true

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
        selectedImageVar = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.selectedImage.image = selectedImageVar
//        self.selectedImage.contentMode = .scaleAspectFill
//        self.selectedImage.layer.masksToBounds = false
//        self.selectedImage.layer.cornerRadius = self.selectedImage.frame.width / 2
//        self.selectedImage.clipsToBounds = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        if (isFormValid()) {
            loading.startAnimating()
            
            let reviewId = Model.instance.generateReviewId()
            Model.instance.saveReviewImage(image: self.selectedImageVar!, reviewId: reviewId) { imageUrl in
                if imageUrl != "" {
                    let review = Review.createReview(id: reviewId, movieName: self.movieName.text!, releaseYear: Int64(self.year.text!)!, genre: self.genre.text!, imageUrl: imageUrl, rating: Int64(self.rating.text!)!, review: self.reviewText.text!, userId: Auth.auth().currentUser!.uid, lastUpdated: 0)
                    
                    Model.instance.add(review: review) { isAdded in
                        if isAdded {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.displayAlert(message: "Failed to create review")
                        }
                    }
                } else {
                    self.displayAlert(message: "Failed to create review")
                }
            }
        }
    }
    
    func isFormValid() -> Bool {
        var isValid = true
        
        checks: if selectedImageVar == nil {
            isValid = false
            displayAlert(message: "Please choose a profile picture")
            break checks
        }
        else if ((self.movieName.text?.isEmpty ?? true) || (year.text?.isEmpty ?? true) || (genre.text?.isEmpty ?? true) || (reviewText.text?.isEmpty ?? true) || (rating.text?.isEmpty ?? true)){
            isValid = false
            displayAlert(message: "Please fill all fields")
            break checks
        }
        else if (Int(rating.text!)! > 5 && Int(rating.text!)! < 0) {
            isValid = false
            displayAlert(message: "Rating must be between 0 to 5")
            break checks
        }
        
        return isValid
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

