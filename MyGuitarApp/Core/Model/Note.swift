
// Note.swift
import Foundation

struct Note: Identifiable, Decodable {
    let id: UUID
    let scoreId: UUID
    let orderIndex: Int
    let startTime: Double
    let duration: Double
    let pitchMidi: Int
    let pitchHz: Double?
    let stringNum: Int?
    let fret: Int?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case scoreId = "score_id"
        case orderIndex = "order_index"
        case startTime = "start_time"
        case duration
        case pitchMidi = "pitch_midi"
        case pitchHz = "pitch_hz"
        case stringNum = "string_num"
        case fret
        case createdAt = "created_at"
    }
}
