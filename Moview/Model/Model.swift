//
//  Model.swift
//  Moview
//
//  Created by admin on 05/07/2021.
//

import Foundation
import UIKit
import CoreData

class NotificationGeneral{
    let name:String
    init(_ name: String){
        self.name = name
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(name), object: self)
    }

    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(name), object: self, queue: nil) { (notification) in
            callback()
        }
    }
}

class Model {
    
    static let instance = Model()
    let modelFirebase = ModelFirebase()
    let usersLastUpdate = "UsersLastUpdateDate"
    let reviewsLastUpdate = "ReviewsLastUpdateDate"
    
    public let notificationReviewsList = NotificationGeneral("notificationReviewsList")
    
    private init(){}
        
    func getAllReviews(callback:@escaping ([Review])->Void){
        var localLastUpdate = Int64(UserDefaults.standard.integer(forKey: reviewsLastUpdate))
        modelFirebase.getAllReviews(lastUpdate: localLastUpdate) { (reviews) in
            if reviews.count > 0 {
                for review in reviews {
                    if review.lastUpdated > localLastUpdate {
                        localLastUpdate = review.lastUpdated
                    }
                }
                
                for review in reviews {
                    if review.wasDeleted {
                        review.delete()
                    }
                }
                
                reviews[0].save()
            }
            
            UserDefaults.standard.setValue(localLastUpdate, forKey: self.reviewsLastUpdate)
            Review.getAll(callback: callback)
            
        }
    }
    
    func generateReviewId()->String {
        return modelFirebase.generateReviewId()
    }
    
    func add(review:Review, callback:@escaping (Bool)->Void){
        modelFirebase.add(review: review) { isAdded in
            if (isAdded) {
                self.notificationReviewsList.post()
            }
            callback(isAdded)
        }
    }
    
    func delete(review:Review, callback:@escaping (Bool)->Void){
        modelFirebase.delete(review: review) { isRemoved in
            if isRemoved {
                self.notificationReviewsList.post()
            }
            callback(isRemoved)
        }
    }
    
    func update(review:Review, callback:@escaping (Bool)->Void){
        modelFirebase.update(review: review) { isUpdated in
            if (isUpdated) {
                self.notificationReviewsList.post()
            }
            callback(isUpdated)
        }
    }
    
    func getReview(byId:String)->Review?{
        return Review.getReview(byId: byId)
    }
    
    func saveProfileImage(image: UIImage, userId: String, callback:@escaping (String)->Void) {
        modelFirebase.saveImage(image: image, path: "profiles", filename: userId, callback: callback)
    }
    
    func saveReviewImage(image: UIImage, reviewId: String, callback:@escaping (String)->Void) {
        modelFirebase.saveImage(image: image, path: "movies", filename: reviewId, callback: callback)
    }
    
    func addUser(user: User, callback:@escaping (Bool)->Void) {
        modelFirebase.addUser(user: user) { isAdded in
            if isAdded {
                //self.notificationStudentList.post()
            }
            
            callback(isAdded)
        }
    }
    
    func getAllUsers(callback:@escaping ([User])->Void){
        var localLastUpdate = Int64(UserDefaults.standard.integer(forKey: usersLastUpdate))
        modelFirebase.getAllUsers(lastUpdate: localLastUpdate) { (users) in
            if users.count > 0 {
                for user in users {
                    if user.lastUpdated > localLastUpdate {
                        localLastUpdate = user.lastUpdated
                    }
                }
                
                for user in users {
                    if user.wasDeleted {
                        user.delete()
                    }
                }
                
                users[0].save()
            }
            
            UserDefaults.standard.setValue(localLastUpdate, forKey: self.usersLastUpdate)
            User.getAll(callback: callback)
        }
    }
    
    func getUser(byId:String) -> User? {
        return User.get(byId: byId)
    }
}
