//
//  Recipe.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/13/25.
//

import Foundation

struct Recipe: Codable, Hashable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
}
