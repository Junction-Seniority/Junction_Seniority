//
//  AppCoordinator.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import Foundation
import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var showReportCompletionModal = false
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
