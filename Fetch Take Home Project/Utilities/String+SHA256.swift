import Foundation
import CryptoKit

extension String {
    /// SHA-256 hex digest of the string.
    func sha256() -> String {
        let data = Data(utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}