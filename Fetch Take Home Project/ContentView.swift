//
//  ContentView.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var cache = DiskCache<[Recipe]>(filename: "recipes")
    @State private var showSorting: Bool = false
    @Environment(RecipeViewModel.self) var viewModel
    @State private var hasError: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filterRecipes(), id: \.self) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeCardView(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .refreshable {
                do {
                    try cache.clear()
                    try ImageDiskCache.shared.removeAll()
                    
                    viewModel.recipes = try await NetworkManager.shared.fetchRecipes()
                    guard !viewModel.recipes.isEmpty else { hasError = true; return }
                    try cache.save(viewModel.recipes)
                    print("Saved to cache")
                } catch {
                    hasError = true
                }
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailsView(recipe: recipe)
            }
            .navigationTitle(Text("Recipes"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showSorting = true
                    } label: {
                        Image(systemName: "line.3.horizontal.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showSorting) {
            FilteringView()
        }
        .task {
            do {
                if let cached = cache.load() {
                    viewModel.recipes = cached
                } else {
                    viewModel.recipes = try await NetworkManager.shared.fetchRecipes()
                    guard !viewModel.recipes.isEmpty else { hasError = true; return }
                    try cache.save(viewModel.recipes)
                }
                viewModel.createFilterOptions()
                await ImagePrefetcher.prefetchImages(for: viewModel.recipes)
                
            } catch {
                hasError = true
            }
        }
        .alert(isPresented: $hasError) {
            Alert(title: Text("Error"), message: Text("Recipes are malformed or not available"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
        .environment(RecipeViewModel())
}
