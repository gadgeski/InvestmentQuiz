//
//  QuizAPI.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/16.
//

import Foundation

enum QuizAPI {
    static func fetchQuestions() async throws -> RemoteQuizPayload {
        let url = APIConfig.baseURL.appendingPathComponent("/api/quiz/v1/questions")
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(RemoteQuizPayload.self, from: data)
    }
}
