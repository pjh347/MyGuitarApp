// Note.swift
import Foundation

struct Note: Identifiable, Decodable {
    let id: UUID            // id: note 개별 ID
    let scoreId: UUID       // scoreId: 해당 scoreId
    let orderIndex: Int     // orderIndex: note별 악보 상 순서
    let startTime: Double   // startTime: 음 진입 시간(박자)
    let duration: Double    // duration: 음 유지 시간(박자)
    let pitchMidi: Int      // pitchMidi: 피치
    let pitchHz: Double?    // pitchHz: 피치, NULL 가능 -> Optional( 임시, 이후 내용 추가 예정 )
    let stringNum: Int?     // stringNum:, NULL 가능 -> Optional( 임시, 이후 내용 추가 예정 )
    let fret: Int?          // fret: 플렛, NULL 가능 -> Optional( 임시, 이후 내용 추가 예정 )
    let createdAt: String?    // createdAt: 생성 시간, NULL 가능 -> Optional
    
    // camelCase(App) <-> snake_case(DB) 파싱
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
