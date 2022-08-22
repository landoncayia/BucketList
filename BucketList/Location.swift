//
//  Location.swift
//  BucketList
//
//  Created by Landon Cayia on 8/22/22.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
