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
    
    var totalEncounters: String? {
        return json["sighting_count"] as? String
    }
    
    var sex: String? {
        return json["sex"] as? String
    }
    
    var firstDate: String? {
        return json["first_datetime"] as? String
    }
    
    var firstLength: String? {
        return json["first_length"] as? String
    }
    
    var firstContributor: String? {
        return json["first_contributor"] as? String
    }
    
    var firstLocation: String? {
        return json["first_location"] as? String
    }
    
    var lastDate: String? {
        return json["last_datetime"] as? String
    }
    
    var lastLength: String? {
        return json["last_length"] as? String
    }
    
    var lastContributor: String? {
        return json["last_contributor"] as? String
    }
    
    var lastLocation: String? {
        return json["last_location"] as? String
    }
    
    var mainImage: URL? {
        guard let urlString = json["mainImage"] as? String else {
            return nil
        }
        return URL(string: urlString)
    }
    
}
