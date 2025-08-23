//
//  ChatViewModel.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var conversation = ChatConversation()
    @Published var currentMessage = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var selectedModel: ModelType = .solarPro2
    
    private let chatService: ChatServiceProtocol
    
    init(chatService: ChatServiceProtocol = ChatService()) {
        self.chatService = chatService
    }
    
    func sendMessage() {
        guard !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = UIError.emptyMessage.localizedDescription
            return
        }
        
        guard !isLoading else {
            errorMessage = UIError.loadingState.localizedDescription
            return
        }
        
        let messageText = currentMessage
        currentMessage = ""
        errorMessage = ""
        
        // Add user message to conversation
        let userMessage = ChatMessage(role: .user, content: messageText)
        conversation.addMessage(userMessage)
        
        Task {
            await sendMessageAsync(messageText)
        }
    }
    
    private func sendMessageAsync(_ message: String) async {
        isLoading = true
        
        do {
            let response = try await chatService.sendMessage(message, model: selectedModel)
            
            // Add assistant response to conversation
            let assistantMessage = ChatMessage(role: .assistant, content: response.content)
            conversation.addMessage(assistantMessage)
            
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch let error as ValidationError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func clearConversation() {
        conversation = ChatConversation()
        errorMessage = ""
    }
    
    func clearError() {
        errorMessage = ""
    }
    
    var canSendMessage: Bool {
        !isLoading && !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasError: Bool {
        !errorMessage.isEmpty
    }
    
    var messageCount: Int {
        conversation.messages.count
    }
    
    var totalTokensUsed: Int {
        // This would require storing usage info with each message
        // For now, return 0 as placeholder
        return 0
    }
}
