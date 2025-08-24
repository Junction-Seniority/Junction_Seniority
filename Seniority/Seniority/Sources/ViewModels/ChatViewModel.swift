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
    
    @AppStorage("specialNotes") var specialNotes: [String] = []
    
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
        let userMessage = ChatMessage(role: .user, content: messageText, displayContent: messageText)
        conversation.addMessage(userMessage)
        
        Task {
            await sendMessageAsync(messageText)
        }
    }
    
    // 알림장 어투 적용 system prompt 넣은 solar pro2 chat
    func sendMessageWithTuneAdjustSP() {
        guard !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = UIError.emptyMessage.localizedDescription
            return
        }
        
        guard !isLoading else {
            errorMessage = UIError.loadingState.localizedDescription
            return
        }
        
        let messageText = Constants.SystemPrompt.messageExtract + " " + currentMessage

        let uiMessage = currentMessage
        currentMessage = ""
        errorMessage = ""
        
        // Add user message to conversation
        let userMessage = ChatMessage(role: .user, content: messageText, displayContent: uiMessage)
        conversation.addMessage(userMessage)
        
        Task {
            await sendMessageAsync(messageText)
        }
    }
    
    // 메시지 추출 system prompt 넣은 solar pro2 chat
    func sendMessageWithMessageExtractionSP() {
        guard !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = UIError.emptyMessage.localizedDescription
            return
        }
        
        guard !isLoading else {
            errorMessage = UIError.loadingState.localizedDescription
            return
        }
        
        let messageText = Constants.SystemPrompt.messageExtract + " " + currentMessage

        let uiMessage = currentMessage
        currentMessage = ""
        errorMessage = ""
        
        // Add user message to conversation
        let userMessage = ChatMessage(role: .user, content: messageText, displayContent: uiMessage)
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
            let assistantMessage = ChatMessage(role: .assistant, content: response.content, displayContent: response.content)
            if let data = assistantMessage.content.data(using: .utf8) {
                do {
                    let decoded = try JSONDecoder().decode(SpecialNotesResponse.self, from: data)
                    let notes = decoded.special_notes
                    specialNotes = notes
                    print(specialNotes)
                } catch {
                    print("디코딩 실패:", error)
                }
            }
//            conversation.addMessage(assistantMessage)
            
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
