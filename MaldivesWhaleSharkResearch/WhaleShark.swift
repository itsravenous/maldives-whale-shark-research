//
//  WhaleShark.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/2/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import AlgoliaSearch
import InstantSearchCore
import Foundation

struct WhaleShark {
    private let json: JSONObject
    
    init(json: JSONObject) {
        self.json = json
    }
    
    var id: String? {
        return json["id"] as? String
    }
    
    var name: String? {
        return json["name"] as? String
    }
    
    var mainImage: URL? {
        guard let urlString = json["mainImage"] as? String else {
            return nil
        }
        return URL(string: urlString)
    }
    
}
