//
//  ModelFirebase.swift
//  Moview
//
//  Created by admin on 13/07/2021.
//

import Foundation
import Firebase

class ModelFirebase {
    let usersCollection = "users"
    let reviewsCollection = "reviews"

    func saveImage(image: UIImage, path: String, filename: String, callback:@escaping (String)->Void) {
        let imageRef = Storage.storage().reference().child(path).child(filename)
        let data = image.jpegData(compressionQuality: 0.8)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    callback("")
                    return
                }
                
                callback(downloadUrl.absoluteString)
            }
        }
    }
    
    func addUser(user: User, callback:@escaping (Bool)->Void) {
        let db = Firestore.firestore()
        db.collection(usersCollection).document(user.id!).setData(user.toJson()) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback(false)
            }
            else {
                print("Document created successfully!")
                callback(true)
            }
        }
    }
    
    func getAllUsers(lastUpdate: Int64, callback:@escaping ([User])->Void){
        let db = Firestore.firestore()
        db.collection(usersCollection)
            .whereField("lastUpdated", isGreaterThan: Timestamp(seconds: lastUpdate, nanoseconds: 0))
            .getDocuments { snapshot, error in
            if let error = error {
                print("Error reading document: \(error)")
            }
            else {
                if let snapshot = snapshot {
                    var data = [User]()
                    for doc in snapshot.documents {
                        if let user = User.create(json: doc.data()) {
                            data.append(user)
                        }
                    }
                    
                    callback(data)
                    return
                }
            }
            
            callback([User]())
        }
    }
    
    func getAllReviews(lastUpdate: Int64, callback:@escaping ([Review])->Void){
        
        let db = Firestore.firestore()
        db.collection(reviewsCollection)
            .whereField("lastUpdated", isGreaterThan: Timestamp(seconds: lastUpdate, nanoseconds: 0))
            .getDocuments { snapshot, error in
            if let error = error {
                print("Error reading document: \(error)")
            }
            else {
                if let snapshot = snapshot {
                    var data = [Review]()
                    for doc in snapshot.documents {
                        if let review = Review.create(json: doc.data()) {
                            data.append(review)
                        }
                    }
                    
                    callback(data)
                    return
                }
            }
            
            callback([Review]())
        }
    }
    
    func add(review:Review, callback:@escaping (String)->Void){
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        ref = db.collection(reviewsCollection).addDocument(data: review.toJson(withId: "")) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback("")
            }
            else {
                print("Document created successfully!")
                callback(ref!.documentID)
            }
        }
    }
    
    func delete(review:Review, callback:@escaping (Bool)->Void){
        let db = Firestore.firestore()
        db.collection(reviewsCollection).document(review.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                callback(false)
            }
            else {
                print("Document removed successfully!")
                callback(true)
            }
        }
    }
    
    func update(review: Review, callback:@escaping (Bool)->Void) {
        let db = Firestore.firestore()
        db.collection(reviewsCollection).document(review.id!).setData(review.toJson(withId: "true")) { err in
            if let err = err {
                print("Error updating document: \(err)")
                callback(false)
            }
            else {
                print("Document updated successfully!")
                callback(true)
            }
        }
    }
    
}
