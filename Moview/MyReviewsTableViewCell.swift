//
//  MyReviewsTableViewCell.swift
//  Moview
//
//  Created by admin on 18/07/2021.
//

import UIKit
import Cosmos

class MyReviewsTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var MovieNameText: UILabel!
    @IBOutlet weak var releaseYearText: UILabel!
    @IBOutlet weak var genreText: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
