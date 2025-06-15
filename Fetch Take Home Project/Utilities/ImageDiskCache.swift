import PhotosUI

enum ImageCacheError: Error {
    case encodingFailed
}

struct ImageDiskCache {
    static let shared = ImageDiskCache()

    private let directory: URL

    private init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.directory = caches.appendingPathComponent("ImageCache", isDirectory: true)

        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory,
                                                     withIntermediateDirectories: true)
        }
    }

    // MARK: – Read
    
    func image(forKey key: String) -> UIImage? {
        let hashed = key.sha256()
        let url = directory.appendingPathComponent(hashed)
        guard
            FileManager.default.fileExists(atPath: url.path),
            let data = try? Data(contentsOf: url)
        else { return nil }

        return UIImage(data: data)
    }

    // MARK: – Write
    
    func store(_ image: UIImage, forKey key: String) throws {
        let hashed = key.sha256()
        let url = directory.appendingPathComponent(hashed)
        guard let data = image.pngData() else { throw ImageCacheError.encodingFailed }
        try data.write(to: url, options: .atomic)
    }

    // MARK: – Remove
    
    func removeImage(forKey key: String) throws {
        let hashed = key.sha256()
        let url = directory.appendingPathComponent(hashed)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }

    func removeAll() throws {
        let contents = try FileManager.default.contentsOfDirectory(at: directory,
                                                                   includingPropertiesForKeys: nil)
        for file in contents {
            try FileManager.default.removeItem(at: file)
        }
    }
}
