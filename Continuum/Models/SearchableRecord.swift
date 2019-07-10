//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/10/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation

protocol SearchableRecordDelegate {
    func matches(searchTerm: String) -> Bool
}
