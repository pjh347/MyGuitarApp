// Score.swift
import Foundation

struct Score: Identifiable, Decodable, Encodable {
    let id: UUID
    let songId: UUID
    let version: String?
    let instrument: String?
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case songId = "song_id"
        case version
        case instrument
        case createdAt = "created_at"
    }
}
