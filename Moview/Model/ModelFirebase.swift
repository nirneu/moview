//
//  ModelFirebase.swift
//  Moview
//
//  Created by admin on 13/07/2021.
//

import Foundation
import Firebase

class ModelFirebase {

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

}
