//
//  MainView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

/// 선생님 메인 뷰
struct MainView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("개발하기 편하라고 일단 여기 버튼으로 만들어놨어요?")
            
            Button("파일 업로드 뷰") {
                coordinator.push(.fileUpload)
            }
            .buttonStyle(.bordered)
            
            Button("부모 가짜 뷰") {
                coordinator.push(.report)
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("우리 앱 이름 뭐로 해요")
    }
}

#Preview {
    MainView()
}
