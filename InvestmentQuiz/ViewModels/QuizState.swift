//
//  QuizState.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/15.
//

import Foundation
import SwiftUI

final class QuizState: ObservableObject {
    // 差し替え可能に（フォールバックはローカルの静的データ）
    @Published var questions: [QuizQuestion] = InvestmentQuizData.questions

    @Published var currentIndex: Int = 0
    @Published var selectedIndex: Int? = nil
    @Published var showHint: Bool = false
    @Published var isAnswered: Bool = false
    @Published var score: Int = 0

    var currentQuestion: QuizQuestion { questions[currentIndex] }
    var isLastQuestion: Bool { currentIndex == questions.count - 1 }
    var progress: Double { Double(currentIndex) / Double(questions.count) }

    func select(_ index: Int) {
        guard !isAnswered else { return }
        selectedIndex = index
        isAnswered = true
        if index == currentQuestion.correctIndex { score += 1 }
    }

    func next() {
        guard currentIndex < questions.count - 1 else { return }
        currentIndex += 1
        selectedIndex = nil
        showHint = false
        isAnswered = false
    }

    func restart() {
        currentIndex = 0
        selectedIndex = nil
        showHint = false
        isAnswered = false
        score = 0
    }

    // リモート取得結果を反映するための安全な差し替え
    func setQuestions(_ newQuestions: [QuizQuestion]) {
        guard !newQuestions.isEmpty else { return }
        questions = newQuestions
        restart() // 進行状況はリセット
    }
}
