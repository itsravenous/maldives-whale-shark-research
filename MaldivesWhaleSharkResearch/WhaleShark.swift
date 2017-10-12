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
import i3s_swift

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
    
    var media: [String]? {
        var dict = [String]()
        for image in (json["media"] as? [[String:Any]])! {
            if let url = image["thumb_url"] as? String {
                dict.append(url)
            }
        }
        return dict
    }
    
    var fingerPrints: [FingerPrint]? {
        let refs : [Double] = [ 0.0, 0.0, 100.0, 100.0, 0.0, 100.0 ]
        let spots : [Double] = [
            10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0,
            20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
            30.0, 30.0, 30.0, 30.0, 30.0, 30.0, 30.0, 30.0,
            40.0, 40.0, 40.0, 40.0, 40.0, 40.0, 40.0, 40.0
        ]
        return [
            FingerPrint(ref: refs, data: spots, nr: 4)
        ]
    }

}
