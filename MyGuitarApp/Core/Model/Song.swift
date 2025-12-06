// Core/Model/Song.swift

import Foundation

struct Song: Identifiable, Decodable, Encodable, Hashable {
    let id: UUID                 // id: song의 ID
    let title: String            // title: 악보(노래) 제목
    let artist: String?          // artist: 작곡가, NULL 가능 -> Optional
    let bpm: Int?                // bpm: 박자, NULL 가능 -> Optional
    let difficulty: Int?         // difficulty: 난이도, NULL 가능 -> Optional
    let createdAt: Date?         // cretedAt: 생성 시간, created_at -> createdAt + Date, NULL 가능 -> Optional

    // camelCase(App) <-> snake_case(DB) 파싱
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artist
        case bpm
        case difficulty
        case createdAt = "created_at"
    }
}
