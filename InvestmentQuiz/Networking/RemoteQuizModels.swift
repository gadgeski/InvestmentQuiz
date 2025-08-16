//
//  RemoteQuizModels.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/16.
//

import Foundation

struct RemoteQuizPayload: Decodable {
    let version: Int
    let questions: [RemoteQuizQuestion]
}

struct RemoteQuizQuestion: Decodable {
    let id: UUID
    let question: String
    let choices: [String]
    let correctIndex: Int
    let hint: String
    let explanation: String
    let difficulty: String // "初級" | "中級" | "上級"（現状UIでは未使用）
}
