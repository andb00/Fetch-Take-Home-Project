//
//  NetworkManager.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/13/25.
//

import Foundation

protocol MockableNetworkManager {
    func fetchRecipes() async throws -> [Recipe]
}

actor NetworkManager: MockableNetworkManager {
    static let shared = NetworkManager()
    private let decoder: JSONDecoder
    private let session: URLSession
    
    private init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.decoder = decoder
        self.session = session
        
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private struct RecipeResponse: Decodable {
        let recipes: [Recipe]
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL(endpoint)
        }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        
        let decoadedRecipes = try self.decoder.decode(RecipeResponse.self, from: data)
        return decoadedRecipes.recipes
    }
}
