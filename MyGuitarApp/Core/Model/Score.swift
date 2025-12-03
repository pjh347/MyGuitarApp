// Score.swift
import Foundation

struct Score: Identifiable, Decodable, Encodable {
    let id: UUID                // id: Score ID
    let songId: UUID            // songId: 해당 song ID
    let version: String?        // version: 버전(기본, 쉬운 버전 등), NULL 가능 -> Optional
    let instrument: String?     // instrument: 악기(피아노, 기타, 바이올린), NULL 가능 -> Optional
    let createdAt: Date?        // createdAt: 생성 시간, NULL 가능 -> Optional

    // camelCase(App) <-> snake_case(DB) 파싱
    enum CodingKeys: String, CodingKey {
        case id
        case songId = "song_id"
        case version
        case instrument
        case createdAt = "created_at"
    }
}
