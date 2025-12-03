// SongApiConfig.example.swift

import Foundation

//struct SongApiConfig {
struct SongApiConfigExample {
    // Supabase의 connect 정보
    static let projectURL = "https://mcrum~~~~~.supabase.co"
    static let apiKey = "eyJhb~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.eyJ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    
    // SONGS -------------------------------------------------
    
    /// songs 전체 조회용 (select=*)
    static var songsURL: URL {
        URL(string: "\(projectURL)/rest/v1/songs?select=*")!
    }

    /// songs CRUD용 기본 URL (/songs)
    static var songsBaseURL: URL {
        URL(string: "\(projectURL)/rest/v1/songs")!
    }

    // SCORES ------------------------------------------------

    /// scores 기본 URL (/scores)
    static var scoresBaseURL: URL {
        URL(string: "\(projectURL)/rest/v1/scores")!
    }

    /// 특정 song에 속한 scores 조회용
    static func scoresURL(forSongId id: UUID) -> URL {
        URL(string: "\(projectURL)/rest/v1/scores?select=*&song_id=eq.\(id.uuidString)")!
    }

    // NOTES -------------------------------------------------

    /// 특정 score에 속한 notes 조회용
    static func notesURL(forScoreId id: UUID) -> URL {
        URL(string: "\(projectURL)/rest/v1/notes?select=*&score_id=eq.\(id.uuidString)")!
    }
}
