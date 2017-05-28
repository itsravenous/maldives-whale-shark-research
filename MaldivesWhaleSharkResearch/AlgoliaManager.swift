//
//  AlgoliaManager.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/28/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import AFNetworking
import AlgoliaSearch
import Foundation


private let DEFAULTS_KEY_MIRRORED       = "algolia.mirrored"
private let DEFAULTS_KEY_STRATEGY       = "algolia.requestStrategy"
private let DEFAULTS_KEY_TIMEOUT        = "algolia.offlineFallbackTimeout"


class AlgoliaManager: NSObject {
    /// The singleton instance.
    static let sharedInstance = AlgoliaManager()
    
    let client: Client
    var sharksIndex: Index
    
    private override init() {
        let apiKey = Bundle.main.infoDictionary!["AlgoliaApiKey"] as! String
        client = Client(appID: "G5XYL55R6R", apiKey: apiKey)
        sharksIndex = client.index(withName: "sharks")
    }
}
