//
//  FilterManager.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/14/25.
//

import Foundation

@Observable
class RecipeViewModel {
    var recipes: [Recipe]
    var filterOptions: [String]
    var toggles: [Bool]
    
    init() {
        self.recipes = []
        self.filterOptions = []
        self.toggles = []
    }
    
    func createFilterOptions() {
        var uniqueCuisines: [Recipe] = []
        var seen = Set<String>()
        uniqueCuisines = recipes.filter { seen.insert($0.cuisine).inserted }
        
        uniqueCuisines.forEach { recipe in
            filterOptions.append(recipe.cuisine)
            toggles.append(true)
        }
    }
    
    func filterRecipes() -> [Recipe] {
        var filteredRecipes: [Recipe] = []
        var index = 0
        for toggle in toggles {
            if toggle {
                filteredRecipes.append(contentsOf: recipes.filter { $0.cuisine == filterOptions[index] })
            }
            index += 1
        }
        return filteredRecipes
    }
}
