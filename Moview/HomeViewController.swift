//
//  HomeViewController.swift
//  Moview
//
//  Created by admin on 05/07/2021.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var newReviewBtn: UIBarButtonItem!
    
    var data = [Review]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action:#selector(refresh) , for: .valueChanged)
        
        reloadData()
        Model.instance.notificationReviewsList.observe {
            self.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if (data.count == 0) {
//            listScroller.startAnimating()
//        }

    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadData()
    }
    
    func reloadData(){
        refreshControl.beginRefreshing()
        Model.instance.getAllUsers() { users in
            Model.instance.getAllReviews { reviews in
                self.data = reviews
                self.reviewsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
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
        cell.releaseYear.text = String(review.releaseYear)
        cell.genre.text = review.genre
        cell.imageView!.kf.setImage(with: URL(string: review.imageUrl!))
        
        if let user = Model.instance.getUser(byId: review.userId!) {
            cell.userName.text = user.fullName
        }
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    /* Table view delegate */

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
