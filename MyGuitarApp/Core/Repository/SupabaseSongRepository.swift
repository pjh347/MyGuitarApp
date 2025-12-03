// SupabaseSongRepository.swift

import Foundation

final class SupabaseSongRepository: SongRepository {

    // MARK: -REQUEST
    private func makeRequest(url: URL,
                             method: String,
                             body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SongApiConfig.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("return=representation", forHTTPHeaderField: "Prefer")
            request.httpBody = body
        }
        return request
    }
    
    // MARK: -FETCH
    func fetchSongs() async throws -> [Song] {
        let request = makeRequest(url: SongApiConfig.songsURL, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseSongRepository",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "fetchSongs 실패: \(body)"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Song].self, from: data)
    }

    // MARK: -ADD
    func addSong(_ song: Song) async throws -> Song {
        let body = try JSONEncoder().encode(song)
        let request = makeRequest(url: SongApiConfig.songsBaseURL,
                                  method: "POST",
                                  body: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let bodyStr = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseSongRepository",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "addSong 실패: \(bodyStr)"])
        }

        // return=representation 이라면 [Song] 으로 와서 첫 번째가 방금 추가된 행
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let created = try? decoder.decode([Song].self, from: data).first {
            return created
        } else {
            // 못 디코딩해도 최소한 우리가 넘긴 song은 리턴
            return song
        }
    }

    // MARK: -DELETE
    func deleteSong(id: UUID) async throws {
        // /songs?id=eq.<uuid>
        var components = URLComponents(url: SongApiConfig.songsBaseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "id", value: "eq.\(id.uuidString)")
        ]
        let url = components.url!

        let request = makeRequest(url: url, method: "DELETE")
        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let bodyStr = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseSongRepository",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "deleteSong 실패: \(bodyStr)"])
        }
    }
}
