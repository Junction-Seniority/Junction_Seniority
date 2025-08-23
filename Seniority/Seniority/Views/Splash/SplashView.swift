//
//  SplashView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack {
            Text("Seniority")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("로딩 중...")
                .foregroundColor(.secondary)
            
            Button("메인으로 이동") {
                coordinator.push(.main)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SplashView()
}
