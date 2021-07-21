//
//  ReviewDetailsViewController.swift
//  Moview
//
//  Created by admin on 21/07/2021.
//

import UIKit
import Kingfisher

class ReviewDetailsViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var review: UITextView!
    
    var reviewObejct: Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Model.instance.getUser(byId: reviewObejct!.userId!) {
            userName.text = user.fullName
        }
        movieTitle.text = reviewObejct!.movieName
        year.text = String(reviewObejct!.releaseYear)
        genre.text = reviewObejct!.genre
        posterImage.kf.setImage(with: URL(string: reviewObejct!.imageUrl!),placeholder: UIImage(named: "Default Avatar"))
        review.text = reviewObejct!.review

       
    }
}
