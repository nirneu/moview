//
//  NewReviewViewController.swift
//  Moview
//
//  Created by admin on 13/07/2021.
//

import UIKit

class NewReviewViewController: UIViewController {

    @IBOutlet weak var movieName: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var summary: UITextField!
    @IBOutlet weak var reviewText: UITextField!
    
    var data = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSave(_ sender: Any) {
        var maxID: Int32 = 0
        Model.instance.getAllReviews { reviews in
            self.data = reviews
            maxID = reviews.map { $0.id }.max() ?? 0
        }
        
        let review = Review.createReview(id: maxID + 1, movieName: movieName.text!, releaseYear: year.text!, genre: genre.text!, imageUrl: "", rating: "5", summary: summary.text!, review: reviewText.text!, userName: "Max")
        Model.instance.add(review: review)
        _ = navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
