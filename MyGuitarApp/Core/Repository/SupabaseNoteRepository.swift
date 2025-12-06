// SupabaseNoteRepository.swift

import Foundation

final class SupabaseNoteRepository: NoteRepository {

    // MARK: - REQUEST 공통 설정
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

    // MARK: - FETCH
    func fetchNotes(for scoreId: UUID) async throws -> [Note] {
        let url = SongApiConfig.notesURL(forScoreId: scoreId)
        let request = makeRequest(url: url, method: "GET")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "SupabaseNoteRepository",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "fetchNotes 실패: \(body)"])
        }

        let decoder = JSONDecoder()
        // createdAt은 String? 이라 dateDecodingStrategy 설정 필요 없음
        return try decoder.decode([Note].self, from: data)
    }
}
