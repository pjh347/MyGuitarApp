// SupabaseScoreRepository.swift

import Foundation

final class SupabaseScoreRepository: ScoreRepository {

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

    func fetchScores(for songId: UUID) async throws -> [Score] {
        let url = SongApiConfig.scoresURL(forSongId: songId)
        let request = makeRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseScoreRepository",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "fetchScores 실패: \(body)"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Score].self, from: data)
    }

    func addScore(_ score: Score) async throws -> Score {
        let body = try JSONEncoder().encode(score)
        let request = makeRequest(url: SongApiConfig.scoresBaseURL,
                                  method: "POST",
                                  body: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let bodyStr = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseScoreRepository",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "addScore 실패: \(bodyStr)"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let created = try? decoder.decode([Score].self, from: data).first {
            return created
        } else {
            return score
        }
    }

    func deleteScore(id: UUID) async throws {
        var components = URLComponents(url: SongApiConfig.scoresBaseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "id", value: "eq.\(id.uuidString)")
        ]
        let url = components.url!

        let request = makeRequest(url: url, method: "DELETE")
        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let bodyStr = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseScoreRepository",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "deleteScore 실패: \(bodyStr)"])
        }
    }
}
