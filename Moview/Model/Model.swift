//
//  Model.swift
//  Moview
//
//  Created by admin on 05/07/2021.
//

import Foundation
import UIKit
import CoreData

class Model {
    
    static let instance = Model()
    let modelFirebase = ModelFirebase()
    let usersLastUpdate = "UsersLastUpdateDate"
    
    private init(){}
        
    func getAllReviews(callback:@escaping ([Review])->Void){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Review.fetchRequest() as NSFetchRequest<Review>
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        DispatchQueue.global().async {
            // second thread code
            var data = [Review]()
            do {
                data = try context.fetch(request)
            } catch {
            }
            
            DispatchQueue.main.async {
                // code to execute on main thread
                callback(data)
            }
        }
    }
    
    func add(review:Review){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func delete(review:Review){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(review)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func getReview(byId:String)->Review?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Review.fetchRequest() as NSFetchRequest<Review>
        request.predicate = NSPredicate(format: "id == \(byId)")
        do {
            let reviews = try context.fetch(request)
            if reviews.count > 0 {
                return reviews[0]
            }
        } catch {
            
        }
        return nil
    }
    
    func saveProfileImage(image: UIImage, userId: String, callback:@escaping (String)->Void) {
        modelFirebase.saveImage(image: image, path: "profiles", filename: userId, callback: callback)
    }
    
    func saveReviewImage(image: UIImage, userId: String, callback:@escaping (String)->Void) {
        modelFirebase.saveImage(image: image, path: "movies", filename: userId, callback: callback)
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
