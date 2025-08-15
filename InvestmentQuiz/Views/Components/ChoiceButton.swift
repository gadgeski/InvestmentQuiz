//
//  ChoiceButton.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/15.
//

import SwiftUI

struct ChoiceButton: View {
    let title: String
    let state: ButtonState

    enum ButtonState {
        case normal
        case correct
        case wrong
        case disabled
    }

    var body: some View {
        let bg: Color
        let border: Color
        switch state {
        case .normal:  bg = Color(.systemBackground); border = Color(.systemGray3)
        case .correct: bg = Color.green.opacity(0.15); border = .green
        case .wrong:   bg = Color.red.opacity(0.15);   border = .red
        case .disabled:bg = Color(.systemGray6);       border = Color(.systemGray4)
        }

        return Text(title)
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 14).fill(bg))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(border, lineWidth: 1))
    }
}
