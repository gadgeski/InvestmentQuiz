//
//  QuizView.swift
//  InvestmentQuiz
//
//  Created by Dev Tech on 2025/08/15.
//

import SwiftUI
import UIKit

struct QuizView: View {
    @StateObject private var vm = QuizState()
    @AppStorage("highScore") private var highScore = 0
    @State private var didSetNewHighScore = false

    var body: some View {
        ZStack {
            // ===== メインUI =====
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Text("投資クイズ")
                            .font(.title2).bold()
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("スコア \(vm.score)/\(vm.questions.count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("ベスト \(highScore)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    ProgressBar(progress: vm.progress)
                    HStack {
                        Text("Q\(vm.currentIndex + 1)/\(vm.questions.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("難易度: \(Difficulty.forIndex(vm.currentIndex).rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                // Card
                VStack(alignment: .leading, spacing: 16) {
                    Text(vm.currentQuestion.question)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)

                    // Hint
                    if vm.showHint {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb")
                            Text(vm.currentQuestion.hint)
                                .font(.subheadline)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.yellow.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.yellow.opacity(0.6), lineWidth: 1)
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    Button {
                        withAnimation { vm.showHint.toggle() }
                    } label: {
                        Label(vm.showHint ? "ヒントを隠す" : "ヒントを見る", systemImage: "questionmark.circle")
                            .font(.subheadline)
                    }

                    // Choices
                    VStack(spacing: 10) {
                        ForEach(vm.currentQuestion.choices.indices, id: \.self) { idx in
                            Button { vm.select(idx) } label: {
                                ChoiceButton(
                                    title: vm.currentQuestion.choices[idx],
                                    state: buttonState(for: idx)
                                )
                            }
                            .disabled(vm.isAnswered)
                        }
                    }

                    // Result & Explanation
                    if vm.isAnswered {
                        let isCorrect = vm.selectedIndex == vm.currentQuestion.correctIndex
                        HStack(spacing: 8) {
                            Image(systemName: isCorrect ? "checkmark.seal.fill" : "xmark.octagon.fill")
                                .foregroundColor(isCorrect ? .green : .red)
                            Text(isCorrect ? "正解！" : "不正解")
                                .font(.headline)
                                .foregroundColor(isCorrect ? .green : .red)
                        }
                        .padding(.top, 4)

                        Text(vm.currentQuestion.explanation)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 2)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                )
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)

                Spacer()

                // Footer buttons
                HStack {
                    Button {
                        withAnimation {
                            vm.restart()
                            didSetNewHighScore = false
                        }
                    } label: {
                        Label("最初からやり直す", systemImage: "arrow.counterclockwise")
                    }

                    Spacer()

                    if vm.isLastQuestion && vm.isAnswered {
                        HStack(spacing: 12) {
                            if didSetNewHighScore {
                                Label("ベスト更新！ \(highScore)点", systemImage: "star.fill")
                                    .foregroundColor(.orange)
                                    .font(.subheadline)
                            }
                            Button {
                                withAnimation {
                                    vm.restart()
                                    didSetNewHighScore = false
                                }
                            } label: {
                                Label("結果: \(vm.score)/\(vm.questions.count)  再挑戦", systemImage: "flag.checkered")
                                    .font(.headline)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        Button {
                            withAnimation { vm.next() }
                        } label: {
                            Label(vm.isAnswered ? "次の問題へ" : "スキップ", systemImage: "chevron.right.circle.fill")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(vm.isLastQuestion && !vm.isAnswered)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .disabled(vm.isLoading)                 // ロード中は操作無効化
            .blur(radius: vm.isLoading ? 1 : 0)     // 視覚的にブラー

            // ===== 読み込みインジケータ（オーバーレイ） =====
            if vm.isLoading {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView("読み込み中…")
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(radius: 8)
            }
        }
        // 初回フェッチ（サーバーが落ちていればフォールバックでローカル問題を使用）
        .task {
            await vm.loadFromServerIfAvailable()
        }
        // iOS17+ の onChange（0パラメータ版）
        .onChange(of: vm.isAnswered, initial: false) {
            if vm.isAnswered && vm.isLastQuestion {
                updateHighScoreIfNeeded()
            }
        }
        .animation(.easeInOut, value: vm.isLoading)
        .animation(.easeInOut, value: vm.showHint)
        .animation(.easeInOut, value: vm.isAnswered)
        .animation(.easeInOut, value: vm.currentIndex)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }

    // 選択肢ボタンの見た目状態
    private func buttonState(for idx: Int) -> ChoiceButton.ButtonState {
        guard let selected = vm.selectedIndex else { return .normal }
        if !vm.isAnswered { return .normal }
        if idx == vm.currentQuestion.correctIndex { return .correct }
        if idx == selected && idx != vm.currentQuestion.correctIndex { return .wrong }
        return .disabled
    }

    // ハイスコア更新
    private func updateHighScoreIfNeeded() {
        if vm.score > highScore {
            highScore = vm.score
            didSetNewHighScore = true
        } else {
            didSetNewHighScore = false
        }
    }
}
