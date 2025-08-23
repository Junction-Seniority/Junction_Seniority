//
//  ChatService.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

protocol ChatServiceProtocol {
    func sendMessage(_ message: String, model: ModelType) async throws -> ChatResponse
    func validateMessage(_ message: String) throws
}

class ChatService: ChatServiceProtocol {
    private let apiClient: APIClientProtocol
    private let mapper: ChatMapperProtocol
    
    init(apiClient: APIClientProtocol = APIClient(), mapper: ChatMapperProtocol = ChatMapper()) {
        self.apiClient = apiClient
        self.mapper = mapper
    }
    
    func sendMessage(_ message: String, model: ModelType = .solarPro2) async throws -> ChatResponse {
        try validateMessage(message)
        
        let requestDTO = mapper.toRequestDTO(message: message, model: model)
        let responseDTO = try await apiClient.sendChatRequest(requestDTO)
        return mapper.toDomainModel(from: responseDTO)
    }
    
    func validateMessage(_ message: String) throws {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidationError.messageTooShort
        }
        
        guard message.count <= 1000 else {
            throw ValidationError.messageTooLong
        }
    }
}

protocol ChatMapperProtocol {
    func toRequestDTO(message: String, model: ModelType) -> ChatRequestDTO
    func toDomainModel(from dto: ChatResponseDTO) -> ChatResponse
}

class ChatMapper: ChatMapperProtocol {
    func toRequestDTO(message: String, model: ModelType) -> ChatRequestDTO {
        return ChatRequestDTO(
            model: model.rawValue,
            messages: [
                MessageDTO(role: MessageRole.user.rawValue, content: message)
            ],
            reasoning_effort: "high",
            stream: false
        )
    }
    
    func toDomainModel(from dto: ChatResponseDTO) -> ChatResponse {
        let content = extractContent(from: dto)
        let usage = dto.usage.map { usageDTO in
            TokenUsage(
                promptTokens: usageDTO.prompt_tokens,
                completionTokens: usageDTO.completion_tokens,
                totalTokens: usageDTO.total_tokens
            )
        }
        
        return ChatResponse(
            id: dto.id,
            content: content,
            model: dto.model,
            usage: usage,
            finishReason: dto.choices.first?.finish_reason
        )
    }
    
    private func extractContent(from dto: ChatResponseDTO) -> String {
        guard let firstChoice = dto.choices.first else {
            return ""
        }
        
        // For non-streaming responses, content is in message.content
        if let messageContent = firstChoice.message?.content {
            return messageContent
        }
        
        // For streaming responses, content is in delta.content
        if let deltaContent = firstChoice.delta?.content {
            return deltaContent
        }
        
        return ""
    }
}
