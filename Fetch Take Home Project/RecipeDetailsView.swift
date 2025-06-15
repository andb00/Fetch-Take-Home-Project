//
//  RecipeDetailsView.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/13/25.
//

import SwiftUI
import PhotosUI

struct RecipeDetailsView: View {
    let recipe: Recipe
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    // Try to loade cached image
                    if let largeImageUrl = recipe.photoUrlLarge {
                        if let cachedImage = ImageDiskCache.shared.image(forKey: largeImageUrl) {
                            Image(uiImage: cachedImage)
                                .resizable()
                                .frame(width: geometry.size.width, height: abs(geometry.size.height - 349))
                            
                        } else {
                            AsyncImage(url: URL(string: largeImageUrl)) { phase in
                                switch phase {
                                case .success(let recipeImage):
                                    recipeImage
                                        .resizable(resizingMode: .stretch)
                                        .renderingMode(.original)
                                        .frame(width: geometry.size.width, height: geometry.size.height - 349)
                                    
                                case .failure:
                                    Text("Failed to Load Image")
                                        .frame(width: geometry.size.width, height: geometry.size.height - 349)
                                        .foregroundColor(.red)
                                        .font(.headline)
                                case .empty:
                                    ZStack {
                                        Rectangle()
                                            .fill(.gray)
                                            .frame(width: geometry.size.width, height: abs(geometry.size.height - 349))
                                        ProgressView()
                                            .font(.largeTitle)
                                    }
                                    
                                @unknown default:
                                    Text("Unknown Error")
                                        .frame(width: geometry.size.width, height: geometry.size.height - 349)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    } else {
                        Text("No Image Available")
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.largeTitle)
                        
                        Text(recipe.cuisine)
                            .font(.headline)
                        
                        Divider()
                        
                        Text("Recipe:")
                            .font(.headline)
                        if let link = recipe.sourceUrl, let url = URL(string: link) {
                            Link("Tap here", destination: url)
                        } else {
                            Text("No Recipe Available")
                                .font(.caption)
                        }
                        
                        Divider()
                        
                        Text("Video:")
                            .font(.headline)
                        if let videoLink = recipe.youtubeUrl, let url = URL(string: videoLink) {
                            Link("Watch Here", destination: url)
                        } else {
                            Text("No YouTube Video Available")
                                .font(.caption)
                        }
                    }
                    Spacer()
                }
                .padding(.leading)
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailsView(
            recipe: Recipe(
                uuid: "",
                name: "Tacos",
                cuisine: "Mexican",
                photoUrlLarge: "https://danosseasoning.com/wp-content/uploads/2022/03/Beef-Tacos-1024x767.jpg",
                photoUrlSmall: nil,
                sourceUrl: "https://feelgoodfoodie.net/recipe/ground-beef-tacos-napa-cabbage-guacamole/",
                youtubeUrl: nil
            )
        )
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Back") {
                    
                }
            }
        }
    }
}
extension Image {
  /// Renders the SwiftUI `Image` into a `UIImage`.
  /// - Parameter scale: 1 by default; pass `UIScreen.main.scale` for pixel-perfect output.
    @MainActor func asUIImage(scale: CGFloat = 1) -> UIImage? {
      let renderer = ImageRenderer(content: self)
      renderer.scale = scale
      return renderer.uiImage
  }
}

