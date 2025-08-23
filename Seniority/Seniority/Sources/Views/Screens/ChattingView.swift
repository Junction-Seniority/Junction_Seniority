//
//  ChattingView.swift
//  Seniority
//
//  Created by 이현주 on 8/24/25.
//

import SwiftUI

struct ChattingView: View {
    @StateObject var viewModel = ChatViewModel()
    
    var contents: String
    
    var body: some View {
        ZStack {
            Color.prime40
                .ignoresSafeArea(edges: .bottom)
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
                            Text(contents)
                                .body02_16Regular()
                                .padding(.all, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                }
                            
                            Text(Date().timeKorean)
                                .foregroundStyle(Color.black70)
                                .body03_14Light()
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    inputView
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea(edges: .top)
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

#Preview {
    ChattingView(contents: """
                 안녕하세요 민규 어머니!️
                 
                 오늘 민규는 블록 놀이 시간에 먼저 작은 블록을 하나씩 쌓아 올리며 즐겁게 활동했어요. 차곡차곡 올리던 탑이 점점 커지자 손으로 살짝 받쳐주며 무너지지 않도록 조심하는 모습이 참 귀여웠습니다. 옆에 있던 친구가 블록을 들고 오자 “여기 올려!”라고 말하며 자리를 내주는 배려심도 보여 주었답니다. 친구와 함께 높은 탑을 완성했을 때는 두 손을 들고 “와~ 높다!”라고 환하게 웃는 모습이 정말 인상적이었어요.^^
                 
                 점심은 준비된 반찬을 골고루 잘 먹었고, 간식으로 나온 과일도 맛있게 먹었습니다. 배변도 규칙적으로 잘 이루어져서 별다른 어려움이 없었어요.
                 
                 다음 주 월요일에는 미술 시간이 예정되어 있으니 크레파스와 도화지를 챙겨주시면 아이들이 더욱 즐겁게 활동할 수 있을 것 같습니다. 
                 
                 오늘 친구와 함께 블록을 쌓으며 협동하는 즐거움을 경험한 민규의 모습이 참 자랑스러웠습니다.
                 
                 주말 동안에도 가족과 함께 즐거운 놀이 시간 보내시길 바랍니다. 감사합니다 🌸
                 """)
}
