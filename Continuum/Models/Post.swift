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
    
    // Class Properties
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var comments: [Comment]
    var recordID: CKRecord.ID
    var commentCount: Int
    
    var photo: UIImage? {
        get {
            guard let data = photoData else {return nil}
            return UIImage(data: data)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage, caption: String, timestamp: Date = Date(), comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int = 0) {
        
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.recordID = recordID
        self.commentCount = commentCount
        self.photo = photo
    }
    
    convenience init?(record: CKRecord) {
        guard let caption = record[PostConstants.captionKey] as? String,
        let timestamp = record[PostConstants.timestampKey] as? Date,
        let imageAsset = record[PostConstants.imageAssetKey] as? CKAsset,
        let commentCount = record[PostConstants.commentCountKey] as? Int
        else {return nil}
        
        //This should never fail
        guard let photoData = try? Data(contentsOf: imageAsset.fileURL!) else {return nil}
        guard let photo = UIImage(data: photoData)
            else {return nil}
        
        
        self.init(photo: photo, caption: caption, timestamp: timestamp, recordID: record.recordID, commentCount: commentCount)
    }
    
//     init?(record: CKRecord) {
//        guard let caption = record[PostConstants.captionKey] as? String,
//        let timestamp = record[PostConstants.timestampKey] as? Date,
//        let imageAsset = record[PostConstants.imageAssetKey] as? CKAsset,
//        let recordID = record[PostConstants.recordIDKey] as? String,
//        let comments = record[PostConstants.commentsKey] as? [Comment]
//            else {return nil }
//
//        self.caption = caption
//        self.timestamp = timestamp
//        self.recordID = recordID
//        self.comments = comments
//
//        do {
//            try self.photoData = Data(contentsOf: imageAsset.fileURL!)
//        } catch let error {
//            print("error retrieving photo from URL \(error), \(error.localizedDescription)")
//        }
//    }
    
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
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostConstants.recordType)
        self.setValue(post.caption, forKey: PostConstants.captionKey)
        self.setValue(post.timestamp, forKey: PostConstants.timestampKey)
        self.setValue(post.imageAsset, forKey: PostConstants.imageAssetKey)
        self.setValue(post.commentCount, forKey: PostConstants.commentCountKey)
//        self.setValue(post.comments, forKey: PostConstants.commentsKey)
    }
}

struct PostConstants {
    static let recordType = "Post"
    fileprivate static let recordIDKey = "RecordID"
    fileprivate static let captionKey = "Caption"
    fileprivate static let timestampKey = "Timestamp"
    fileprivate static let imageAssetKey = "ImageAsset"
    fileprivate static let commentCountKey = "CommentCount"
//    fileprivate static let commentsKey = "Comments"
}
