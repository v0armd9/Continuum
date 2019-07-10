//
//  PostController.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class PostController {
    
    //Shared Instance (singleton)
    static let sharedInstance = PostController()

    //Source of Truth
    var posts: [Post] = []
    
    //Creates a function that takes in text(String) and a post(Post)
    //--along with a closure that takes in a comment and returns void
    func addComment(with text: String, post: Post, completion: @escaping (Comment) -> Void) {
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
        completion(newComment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping(Post?) -> Void) {
        let newPost = Post(photo: image, caption: caption)
        self.posts.append(newPost)
    }
    
    
}//End of Class

