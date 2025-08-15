//
//  QuizQuestion.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/15.
//

import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let choices: [String]
    let correctIndex: Int
    let hint: String
    let explanation: String
}
