//
//  messagesView.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                if viewModel.conversation.messages.isEmpty {
                    EmptyStateView()
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(viewModel.conversation.messages, id: \.id) { message in
                        MessageBubbleView(message: message)
                    }
                }

                // Loading indicator
                if viewModel.isLoading {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Thinking...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }

                // Error view
                if viewModel.hasError {
                    ErrorView(message: viewModel.errorMessage) {
                        viewModel.clearError()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}
