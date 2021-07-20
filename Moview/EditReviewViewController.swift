//
//  EditReviewViewController.swift
//  Moview
//
//  Created by admin on 19/07/2021.
//

import UIKit
import Kingfisher

class EditReviewViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieNameText: UITextField!
    @IBOutlet weak var releaseYearText: UITextField!
    @IBOutlet weak var genreText: UITextField!
    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var ReviewText: UITextView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var reviewId: String = ""
    var review: Review?
    var selectedImage: UIImage?
    
    @IBAction func saveClicked(_ sender: Any) {
        if (isFormValid()){
            loading.startAnimating()
            
            review?.movieName = movieNameText.text!
            review?.releaseYear = Int64(releaseYearText.text!)!
            review?.genre = genreText.text!
            review?.rating = Int64(ratingText.text!)!
            review?.review = ReviewText.text!
            
            if selectedImage != nil {
                Model.instance.saveReviewImage(image: selectedImage!, reviewId: (review?.id)!) { imageUrl in
                    if imageUrl != "" {
                        self.review?.imageUrl = imageUrl
                        self.saveReview()
                    }
                    else {
                        self.displayAlert(message: "Failed to update review")
                        self.loading.stopAnimating()
                    }
                }
            }
            else {
                saveReview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set movie image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        movieImage.isUserInteractionEnabled = true
        movieImage.addGestureRecognizer(tapGestureRecognizer)
        
        ReviewText!.layer.borderWidth = 0.5
        ReviewText!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        ReviewText!.layer.cornerRadius = 5
        ReviewText!.clipsToBounds = true
        
        if let selectedReview = Model.instance.getReview(byId: reviewId) {
            review = selectedReview
            movieNameText.text = review?.movieName!
            releaseYearText.text = String(review!.releaseYear)
            genreText.text = review?.genre
            ratingText.text = String(review!.rating)
            ReviewText.text = review?.review
            movieImage.kf.setImage(with: URL(string: (review?.imageUrl)!), placeholder: UIImage(named: "Default Avatar"))
            loading.stopAnimating()
        }
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
        self.movieImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func isFormValid() -> Bool {
        var isValid = true
        
        checks: if ((self.movieNameText.text?.isEmpty ?? true) || (releaseYearText.text?.isEmpty ?? true) || (genreText.text?.isEmpty ?? true) || (ReviewText.text?.isEmpty ?? true) || (ratingText.text?.isEmpty ?? true)){
            isValid = false
            displayAlert(message: "Please fill all fields")
            break checks
        }
        else if (Int(ratingText.text!)! > 5 && Int(ratingText.text!)! < 0) {
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
    
    func saveReview() {
        Model.instance.update(review: review!) { isUpdated in
            if isUpdated {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.displayAlert(message: "Failed to update review")
                self.loading.stopAnimating()
            }
        }
    }
}
