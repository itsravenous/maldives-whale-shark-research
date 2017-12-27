//
//  ComparisonResult.swift
//  MaldivesWhaleSharkResearch
//
//  Created by user132377 on 10/31/17.
//

import Foundation

struct ComparisonResult {
    var id: String
    var name: String
    var score: Double
    var image: String
}

extension ComparisonResult: Comparable {
    static func == (lhs: ComparisonResult, rhs: ComparisonResult) -> Bool {
        return lhs.id == rhs.id && lhs.score == rhs.score && lhs.image == rhs.image
    }

    static func < (lhs: ComparisonResult, rhs: ComparisonResult) -> Bool {
        return lhs.score < rhs.score
    }

    static func > (lhs: ComparisonResult, rhs: ComparisonResult) -> Bool {
        return lhs.score > rhs.score
    }
}
