//
//  APIConfig.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/16.
//

import Foundation

enum APIConfig {
    #if DEBUG
    static let baseURL = URL(string: "http://127.0.0.1:3000")! // 開発用
    #else
    static let baseURL = URL(string: "https://your-prod.example.com")! // 本番用
    #endif
}
