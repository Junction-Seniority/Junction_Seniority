//
//  ChatModels.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

// MARK: - Domain Models
struct ChatMessage {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    
    init(role: MessageRole, content: String) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
    }
}

enum MessageRole: String, CaseIterable {
    case user = "user"
    case assistant = "assistant"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .user:
            return "You"
        case .assistant:
            return "Assistant"
        case .system:
            return "System"
        }
    }
}

struct ChatConversation {
    let id: UUID
    var messages: [ChatMessage]
    let createdAt: Date
    var updatedAt: Date
    
    init() {
        self.id = UUID()
        self.messages = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func addMessage(_ message: ChatMessage) {
        messages.append(message)
        updatedAt = Date()
    }
}

struct ChatResponse {
    let id: String
    let content: String
    let model: String
    let usage: TokenUsage?
    let finishReason: String?
    let timestamp: Date
    
    init(id: String, content: String, model: String, usage: TokenUsage? = nil, finishReason: String? = nil) {
        self.id = id
        self.content = content
        self.model = model
        self.usage = usage
        self.finishReason = finishReason
        self.timestamp = Date()
    }
}

struct TokenUsage {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    var cost: Double {
        // Estimated cost calculation (adjust based on actual pricing)
        let promptCost = Double(promptTokens) * 0.00001
        let completionCost = Double(completionTokens) * 0.00002
        return promptCost + completionCost
    }
}

enum ModelType: String, CaseIterable {
    case solarPro2 = "solar-pro2"
    
    var displayName: String {
        switch self {
        case .solarPro2:
            return "Solar Pro 2"
        }
    }
    
    var description: String {
        switch self {
        case .solarPro2:
            return "Advanced reasoning model with high performance"
        }
    }
}