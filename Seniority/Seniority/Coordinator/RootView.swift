//
//  RootView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .splash: SplashView()
                    case .main: MainView()
                    case .fileUpload: FileUploadView()
                    case .report: ReportView()
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
