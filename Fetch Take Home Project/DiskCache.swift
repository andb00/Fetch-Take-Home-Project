import Foundation

/// A simple file-based cache for any Codable type.
/// Writes into the Caches directory so the OS can evict it if space is low,
/// but it will persist across launches until you explicitly delete it.
struct DiskCache<T: Codable> {
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(filename: String) {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.fileURL = caches.appendingPathComponent(filename).appendingPathExtension("json")
        encoder.keyEncodingStrategy = .convertToSnakeCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    /// Save the given value to disk. Overwrites any existing file.
    func save(_ value: T) throws {
        let data = try encoder.encode(value)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }

    /// Load the value from disk, or return nil if missing/decoding fails.
    func load() -> T? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    /// Delete the cached file.
    func clear() throws {
        try FileManager.default.removeItem(at: fileURL)
    }
    
    
}
