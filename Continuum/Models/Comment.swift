//
//  Comment.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation
import CloudKit

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
    var recordID: CKRecord.ID
    weak var post: Post?
    
    var recordReference: CKRecord.Reference? {
        guard let post = post else {return nil}
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    
    init(text: String, timestamp: Date = Date(), post: Post, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
        self.post = post
    }
    
    convenience init?(record: CKRecord, post: Post) {
        guard let text = record[CommentConstants.textKey] as? String,
        let timestamp = record[CommentConstants.timestampKey] as? Date
            else {return nil}
        self.init(text: text, timestamp: timestamp, post: post, recordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(comment: Comment) {
        self.init(recordType: CommentConstants.recordType )
        self.setValue(comment.text, forKey: CommentConstants.textKey)
        self.setValue(comment.timestamp, forKey: CommentConstants.timestampKey)
       // self.setValue(comment.recordID, forKey: CommentConstants.recordIDKey)
        self.setValue(comment.recordReference, forKey: CommentConstants.recordReferenceKey)
    }
}

struct CommentConstants {
    static let recordType = "Comment"
    static let recordReferenceKey = "RecordReference"
    fileprivate static let textKey = "Text"
    fileprivate static let timestampKey = "Timestamp"
    fileprivate static let recordIDKey = "RecordID"
}
