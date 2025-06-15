//
//  MockNetworkManager.swift
//  Fetch Take Home ProjectTests
//
//  Created by Andrew Betancourt on 6/14/25.
//

import Foundation
@testable import Fetch_Take_Home_Project

class MockNetworkManager: MockableNetworkManager {
    static let shared = MockNetworkManager()
    var endPointType = ""
    
    func fetchRecipes() async throws -> [Recipe] {
        if endPointType == "malformed" {
            return []
        } else {
            return [
                Recipe(uuid: "1", name: "Tacos", cuisine: "Mexican", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil),
                Recipe(uuid: "2", name: "Musubi", cuisine: "Japanese", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil),
                Recipe(uuid: "3", name: "Cheescake", cuisine: "American", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil),
                
            ]
        }
    }
}
