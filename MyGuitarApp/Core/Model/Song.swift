// Song.swift

import Foundation

struct Song: Identifiable, Decodable, Encodable {
    let id: UUID                // bigint → Int
    let title: String
    let artist: String?          // NULL 가능 → Optional
    let bpm: Int?                // Optional
    let difficulty: Int?         // Optional
    let createdAt: Date?         // created_at → createdAt + Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artist
        case bpm
        case difficulty
        case createdAt = "created_at"
    }
}
