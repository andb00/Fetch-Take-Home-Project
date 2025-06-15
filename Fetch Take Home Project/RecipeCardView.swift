//
//  RecipeCardView.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/13/25.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemGroupedBackground))
                .frame(maxWidth: .infinity, maxHeight: 150)
                .shadow(radius: 5)
            
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        if let imageUrl = recipe.photoUrlSmall {
                            if let cachedImage = ImageDiskCache.shared.image(forKey: imageUrl) {
                                Image(uiImage: cachedImage)
                                    .resizable()
                                    .frame(width: 110, height: 110)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    
                            } else {
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .image?
                                        .resizable(resizingMode: .stretch)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                    }
                    .padding([.vertical, .leading])
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .font(.title)
                            .fontWeight(.medium)
                        
                        Text(recipe.cuisine)
                            .font(.headline)
                    }
                    .padding(.leading, 4)
                    
                    Spacer()
                }
            }
        }
        .padding([.top, .horizontal])
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    RecipeCardView(
        recipe: Recipe(
            uuid: "",
            name: "Chilaquiles",
            cuisine: "Mexican",
            photoUrlLarge: nil,
            photoUrlSmall: "https://assets.epicurious.com/photos/62c4b089bfd689c61cf0ac8c/4:3/w_5013,h_3759,c_limit/Chilaquiles_RECIPE_062922_36571.jpg",
            sourceUrl: nil,
            youtubeUrl: nil
        )
    )
}
