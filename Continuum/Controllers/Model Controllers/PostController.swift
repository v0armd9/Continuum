//
//  PostController.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    
    //Shared Instance (singleton)
    static let sharedInstance = PostController()

    //Source of Truth
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //Creates a function that takes in text(String) and a post(Post)
    //--along with a closure that takes in a comment and returns void
    func addComment(with text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
        let record = CKRecord(comment: newComment)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record  else {completion(nil); return}
                let comment = Comment(record: record, post: post)
            self.incrementCommentCount(for: post, completion: nil)
            completion(comment)
        }
    }
    
    func incrementCommentCount(for post: Post, completion: ((Bool)->Void)?) {
        post.commentCount += 1
        let operation = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion?(false)
                return
            } else {
                completion?(true)
            }
        }
        publicDB.add(operation)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping(Post?) -> Void) {
        let newPost = Post(photo: image, caption: caption)
        self.posts.append(newPost)
        let record = CKRecord(post: newPost)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record,
                let post = Post(record: record) else {completion(nil); return}
            completion(post)
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
            }
            guard let records = records else {completion(nil); return}
            let posts = records.compactMap{ Post(record: $0) }
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchComment(for post: Post, completion: @escaping ([Comment]?) -> Void) {
        let postReference = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentConstants.recordReferenceKey, postReference)
        let commentIDs = post.comments.compactMap({ $0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: CommentConstants.recordType, predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let records = records else {completion(nil); return}
            let comments = records.compactMap{ Comment(record: $0, post: post)}
            post.comments.append(contentsOf: comments)
            completion(comments)
        }
    }
    
}//End of Class

