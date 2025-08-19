//
//  QuizState+Remote.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/16.
//

import Foundation

extension QuizState {
    /// サーバーに問題があれば差し替える。失敗時はフォールバック（何もしない）
    @MainActor
    func loadFromServerIfAvailable() async {
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let remote = try await QuizAPI.fetchQuestions()
            // 最低限の整合性チェック：correctIndex が範囲内
            let valid = remote.questions.filter { q in
                q.correctIndex >= 0 && q.correctIndex < q.choices.count
            }
            let mapped = valid.map(QuizQuestion.fromRemote)
            if !mapped.isEmpty {
                setQuestions(mapped) // 成功時のみ置換（進行は restart 済み）
            }
        } catch {
            // 失敗時は黙ってフォールバック（ローカル問題のまま）
        }
    }
}
