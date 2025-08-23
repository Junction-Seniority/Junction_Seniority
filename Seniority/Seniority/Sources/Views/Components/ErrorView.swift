//
//  ErrorView.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
            
            Spacer()
            
            Button("Dismiss") {
                onDismiss()
            }
            .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}
