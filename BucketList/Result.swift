//
//  Result.swift
//  BucketList
//
//  Created by Landon Cayia on 8/23/22.
//

import Foundation

/// A container that holds the result of a query to the Wikipedia API for places nearby to given GPS coordinates.
struct Result: Codable {
    let query: Query
}

/// A container that holds the pages, as a dictionary, returned within a query to the Wikipedia API for places nearby to given GPS coordinates.
struct Query: Codable {
    let pages: [Int: Page]
}

/// Represents a page returned via a query to the Wikipedia API for places nearby to given GPS coordinates.
struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    /// Pages are sorted alphabetically, by title.
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
