//
//  ContentView.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MessagesView(viewModel: viewModel)

                InputView(viewModel: viewModel)
            }
            .navigationTitle("Seniority Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        viewModel.clearConversation()
                    }
                    .disabled(viewModel.messageCount == 0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
