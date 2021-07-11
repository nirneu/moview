//
//  HomeViewController.swift
//  Moview
//
//  Created by admin on 05/07/2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var listScroller: UIActivityIndicatorView!
    
    var data = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let review = Review.createReview(id: "0", movieName: "Love is in the air", releaseYear: "2012", genre: "Drama", imageUrl: "", rating: "5", summary: "", review: "5", userName: "Max")
//        Model.instance.add(review: review)
//        let r = Model.instance.getReview(byId: "1")
//        Model.instance.delete(review:r!)
        listScroller.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (data.count == 0) {
            listScroller.startAnimating()
        }
        Model.instance.getAllReviews { reviews in
            self.data = reviews
            self.reviewsTableView.reloadData()
            self.listScroller.stopAnimating()
        }
    }
}
    
extension HomeViewController: UITableViewDataSource {
    /* Delegate protocol */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "reviewListRow", for: indexPath) as! ReviewsTableViewCell
        
        let review = data[indexPath.row]
        cell.movieTitle.text = review.movieName
        cell.releaseYear.text = review.releaseYear
        cell.genre.text = review.genre
        cell.userName.text = review.userName
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    /* Table view delegate */

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
