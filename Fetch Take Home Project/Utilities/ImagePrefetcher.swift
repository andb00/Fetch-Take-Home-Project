import Foundation
import PhotosUI

struct ImagePrefetcher {
    /// Downloads & persists every thumbnail in the supplied recipes.
    /// If an image is already cached it is skipped.
    static func prefetchImages(for recipes: [Recipe]) async {
        await withTaskGroup { group in
            for recipe in recipes {
                // Filter out non-nil urls
                let allURLStrings = [recipe.photoUrlSmall, recipe.photoUrlLarge]
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }

                for string in allURLStrings {
                    guard let url = URL(string: string) else { continue }

                    group.addTask {
                        let key = url.absoluteString

                        // Skip if we already have the image.
                        if ImageDiskCache.shared.image(forKey: key) != nil { return }

                        do {
                            print("Executing prefetch task for \(url)")
                            let (data, _) = try await URLSession.shared.data(from: url)
                            if let image = UIImage(data: data) {
                                try ImageDiskCache.shared.store(image, forKey: key)
                            }
                        } catch {
                            // Silently ignore individual-image failures.
                            print("Image prefetch failed for \(url):", error)
                        }
                    }
                }
            }
        }
    }
}
