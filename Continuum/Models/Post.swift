//
//  Post.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class Post: SearchableRecordDelegate {
    
    func matches(searchTerm: String) -> Bool {
        if caption.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            for comment in comments {
                if comment.text.lowercased().contains(searchTerm.lowercased()) {
                    return true
                }
            }
        }
        return false
    }
    
    
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var comments: [Comment]
    
    var photo: UIImage? {
        get {
            guard let data = photoData else {return nil}
            return UIImage(data: data)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(photo: UIImage, caption: String, timestamp: Date = Date(), comments: [Comment] = []) {
        
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.photo = photo
    }
}
