//
//  inputView.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct InputView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Divider()

            HStack(alignment: .bottom, spacing: 12) {
                TextField("Type your message...", text: $viewModel.currentMessage, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1 ... 4)

                Button(action: viewModel.sendMessageWithMessageExtractionSP) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(viewModel.canSendMessage ? .blue : .gray)
                        .font(.title2)
                }
                .disabled(!viewModel.canSendMessage)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
    }
}
