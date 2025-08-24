//
//  RootView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var chatVM = ChatViewModel() 
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .splash: SplashView()
                    case .main: MainView()
                    case .fileUpload: FileUploadView()
                    case .report: ChattingView(viewModel: chatVM)
                    case .reportEdit: ReportEditorView()
                    }
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    RootView()
}
