//
//  QuizMapper.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/16.
//

import Foundation

extension QuizQuestion {
    static func fromRemote(_ r: RemoteQuizQuestion) -> QuizQuestion {
        QuizQuestion(
            question: r.question,
            choices: r.choices,
            correctIndex: r.correctIndex,
            hint: r.hint,
            explanation: r.explanation
        )
    }
}
