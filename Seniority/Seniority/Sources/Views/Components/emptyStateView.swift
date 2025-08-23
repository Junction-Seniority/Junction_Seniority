//
//  emptyStateView.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("아람반 톡")
                .font(.title2)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 50)
    }
}
