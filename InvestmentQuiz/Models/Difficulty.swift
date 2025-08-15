//
//  Difficulty.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/15.
//

import Foundation

enum Difficulty: String {
    case beginner = "初級"
    case intermediate = "中級"
    case advanced = "上級"

    static func forIndex(_ idx: Int) -> Difficulty {
        switch idx {
        case 0...4: return .beginner
        case 5...9: return .intermediate
        default: return .advanced
        }
    }
}
