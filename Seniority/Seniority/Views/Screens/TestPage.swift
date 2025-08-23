//
//  TestPage.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct TestPage: View {
    @State private var keywords = ""
    @State private var generatedReport = ""
    @State private var isGenerating = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let reportService = DailyReportGenerationService()
    private let selectedChild = DummyChild.sampleData.first { $0.name == "김민수" }!
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView()
                    
                    ChildInfoView(child: selectedChild)
                    
                    KeywordInputView(keywords: $keywords, onGenerate: generateReport)
                    
                    if !generatedReport.isEmpty {
                        GeneratedReportView(report: generatedReport)
                    }
                    
                    if isGenerating {
                        LoadingView()
                    }
                }
                .padding()
            }
            .navigationTitle("알림장 생성 테스트")
            .navigationBarTitleDisplayMode(.inline)
            .alert("알림", isPresented: $showAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func generateReport() {
        guard !keywords.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "키워드를 입력해주세요."
            showAlert = true
            return
        }
        
        isGenerating = true
        generatedReport = ""
        
        Task {
            do {
                let report = try await reportService.generateDailyReport(keywords: keywords, child: selectedChild)
                await MainActor.run {
                    generatedReport = report
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    isGenerating = false
                    alertMessage = "알림장 생성 중 오류가 발생했습니다: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("AI 알림장 생성기")
                .font(.title)
                .fontWeight(.bold)
            
            Text("키워드만 입력하면 자동으로 알림장이 작성됩니다")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct ChildInfoView: View {
    let child: Child
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("대상 아이 정보")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "이름", value: child.name)
                InfoRow(label: "나이", value: "\(child.age)세")
                InfoRow(label: "특성", value: child.traits.joined(separator: ", "))
                
                if !child.cautions.allergies.isEmpty {
                    InfoRow(label: "알레르기", value: child.cautions.allergies.joined(separator: ", "), isWarning: true)
                }
                
                if !child.cautions.environment.isEmpty {
                    InfoRow(label: "주의사항", value: child.cautions.environment.joined(separator: ", "), isWarning: true)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var isWarning: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .fontWeight(.medium)
                .foregroundColor(isWarning ? .orange : .primary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .foregroundColor(isWarning ? .orange : .secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct KeywordInputView: View {
    @Binding var keywords: String
    let onGenerate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘의 키워드")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("예: 블록놀이, 친구와 갈등, 점심 잘 먹음, 낮잠 못잠")
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField("키워드를 입력하세요 (쉼표로 구분)", text: $keywords, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3 ... 6)
            
            Button(action: onGenerate) {
                HStack {
                    Image(systemName: "wand.and.stars")
                    Text("알림장 생성하기")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(keywords.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct GeneratedReportView: View {
    let report: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("생성된 알림장")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("복사") {
                    UIPasteboard.general.string = report
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }
            
            Text(report)
                .font(.body)
                .lineSpacing(4)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("알림장을 생성하고 있습니다...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    TestPage()
}
