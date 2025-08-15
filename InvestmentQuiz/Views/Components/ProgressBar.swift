//
//  ProgressBar.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/15.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Double // 0.0 ... 1.0
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(.systemGray5))
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: max(0, min(1, progress)) * geo.size.width)
            }
        }
        .frame(height: 12)
        .accessibilityLabel("進捗")
        .accessibilityValue("\(Int(progress * 100))%")
    }
}
