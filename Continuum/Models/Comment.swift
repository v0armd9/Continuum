//
//  Comment.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation

class Comment: SearchableRecordDelegate {
    
    func matches(searchTerm: String) -> Bool {
        if text.lowercased().contains(searchTerm.lowercased()) {
            return true
        }else {
            return false
        }
    }
    
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post) {
        
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}
