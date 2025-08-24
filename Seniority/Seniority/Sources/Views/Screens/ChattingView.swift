//
//  ChattingView.swift
//  Seniority
//
//  Created by 이현주 on 8/24/25.
//

import SwiftUI

struct ChattingView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    @AppStorage("savedReportData") private var contents: Data = Data()
    
    private var report: SavedReport? {
        guard !contents.isEmpty else { return nil }
        return try? JSONDecoder().decode(SavedReport.self, from: contents)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            CustomNavigationBar(title: "오늘의 알림장")
            
            Group {
                ScrollView {
                    Text("2025년 8월 24일 일요일")
                        .body03_14Light()
                    
                    if viewModel.conversation.messages.isEmpty {
                        EmptyView()
                    } else {
                        ForEach(viewModel.conversation.messages, id: \.id) { message in
                            MessageCellView(message: message)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        if let report = report {
                            Text(report.responseText)
                                .body02_16Regular()
                                .padding(.all, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                }
                            
                            Text(Date().timeKorean)
                                .foregroundStyle(Color.black70)
                                .body03_14Light()
                        } else {
                            EmptyView()
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                inputView
            }
            .padding(.horizontal, 16)
        }
        .background(.prime40)
        .navigationBarHidden(true)
    }
    
    private var inputView: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("메시지 입력", text: $viewModel.currentMessage, axis: .vertical)
                .padding(12) // 내부 여백
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white) // 배경색
                )
                .tint(Color.prime100)
                .lineLimit(1 ... 4)
                .frame(height: 48)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            Button(action: viewModel.sendMessageWithMessageExtractionSP) {
                ZStack {
                    Circle()
                        .foregroundStyle(viewModel.canSendMessage ? Color.prime100 : .gray)
                        .frame(width: 48)
                    
                    Image(.chatbutton)
                }
            }
            .disabled(!viewModel.canSendMessage)
        }
    }
}

