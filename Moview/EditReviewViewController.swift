//
//  EditReviewViewController.swift
//  Moview
//
//  Created by admin on 19/07/2021.
//

import UIKit

class EditReviewViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieNameText: UITextField!
    @IBOutlet weak var releaseYearText: UITextField!
    @IBOutlet weak var genreText: UITextField!
    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var ReviewText: UITextView!
    
    @IBAction func saveClicked(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
