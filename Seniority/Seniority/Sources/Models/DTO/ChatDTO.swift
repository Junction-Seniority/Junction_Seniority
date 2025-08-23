//
//  ChatDTO.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

// MARK: - Request DTOs
struct ChatRequestDTO: Codable {
    let model: String
    let messages: [MessageDTO]
    let reasoning_effort: String
    let stream: Bool
}

struct MessageDTO: Codable {
    let role: String
    let content: String
}

// MARK: - Response DTOs
struct ChatResponseDTO: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [ChoiceDTO]
    let usage: UsageDTO?
    let system_fingerprint: String?
}

struct ChoiceDTO: Codable {
    let index: Int
    let message: MessageDTO?
    let delta: DeltaDTO?
    let finish_reason: String?
    let logprobs: String?
}

struct DeltaDTO: Codable {
    let role: String?
    let content: String?
}

struct UsageDTO: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
    let prompt_tokens_details: TokenDetailsDTO?
    let completion_tokens_details: CompletionTokenDetailsDTO?
}

struct TokenDetailsDTO: Codable {
    let cached_tokens: Int
    let audio_tokens: Int
}

struct CompletionTokenDetailsDTO: Codable {
    let reasoning_tokens: Int
    let audio_tokens: Int
    let accepted_prediction_tokens: Int
    let rejected_prediction_tokens: Int
}