//
//  Review+CoreDataClass.swift
//  
//
//  Created by admin on 15/07/2021.
//
//

import Foundation
import CoreData
import UIKit

@objc(Review)
public class Review: NSManagedObject {
    static func createReview(id:String, movieName: String, releaseYear: String, genre: String, imageUrl: String, rating: String,
                             summary: String, review: String, userName:String)-> Review {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let currReview = Review(context: context)
        currReview.id = id
        currReview.movieName = movieName
        currReview.releaseYear = releaseYear
        currReview.genre = genre
        currReview.imageUrl = imageUrl
        currReview.rating = rating
        currReview.summary = summary
        currReview.review = review
        currReview.userName = userName
        
        return currReview
    }
}
