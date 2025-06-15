//
//  Fetch_Take_Home_ProjectTests.swift
//  Fetch Take Home ProjectTests
//
//  Created by Andrew Betancourt on 6/13/25.
//

import Testing
@testable import Fetch_Take_Home_Project
import PhotosUI

@Suite("Fetching Recipes Tests Suite")
struct Fetch_Take_Home_ProjectTests {

    @Test func testFetchRecipesNotEmpty() async throws {
        MockNetworkManager.shared.endPointType = "sucsessful"
        let recipes = try await MockNetworkManager.shared.fetchRecipes()
        #expect(!recipes.isEmpty, "The API should return at least one Recipe object.")
    }
    
    @Test func testFetchedRecipesHaveValidRequiredFields() async throws {
        let recipes = try await MockNetworkManager.shared.fetchRecipes()
        for recipe in recipes {
            #expect(!recipe.uuid.isEmpty, "uuid should never be empty")
            #expect(!recipe.name.isEmpty, "name should never be empty")
            #expect(!recipe.cuisine.isEmpty, "cuisine should never be empty")
        }
    }
    
    @Test func testFetchedRecipesHaveInvalidRequiredFieldsThrowsError() async throws {
        MockNetworkManager.shared.endPointType = "malformed"
        let recipes = try await MockNetworkManager.shared.fetchRecipes()
        #expect(recipes.isEmpty)
    }
}

@Suite("Cache Tests Suite")
struct CacheTests {

    struct Dummy: Codable, Equatable {
        let id: Int
        let name: String
    }
    
    @Test func testDiskCacheSaveLoadAndClear() throws {
        let filename = "DummyCache_\(UUID().uuidString)"      // unique file so tests are independent
        let cache = DiskCache<[Dummy]>(filename: filename)
        let original: [Dummy] = [.init(id: 1, name: "One"),
                                 .init(id: 2, name: "Two")]
        
        try cache.save(original)
        
        let loaded = cache.load()
        #expect(loaded == original, "Loaded data should match what was saved.")
        
        try cache.clear()
        let afterClear = cache.load()
        #expect(afterClear == nil, "Cache should be empty after calling clear().")
    }
    
    @Test func testImageDiskCacheStoreLoadAndRemove() throws {
        try? ImageDiskCache.shared.removeAll()
        
        let key = "test-image-key"
        let image = UIImage(systemName: "star.fill")!
        
        try ImageDiskCache.shared.store(image, forKey: key)
        
        let retrieved = ImageDiskCache.shared.image(forKey: key)
        #expect(retrieved != nil, "Image should be retrievable after being stored.")
        
        try ImageDiskCache.shared.removeImage(forKey: key)
        let afterSingleRemove = ImageDiskCache.shared.image(forKey: key)
        #expect(afterSingleRemove == nil, "Image should be nil after removeImage(forKey:).")
        
        try ImageDiskCache.shared.store(image, forKey: key)
        try ImageDiskCache.shared.removeAll()
        let afterRemoveAll = ImageDiskCache.shared.image(forKey: key)
        #expect(afterRemoveAll == nil, "All images should be removed after removeAll().")
    }
}
