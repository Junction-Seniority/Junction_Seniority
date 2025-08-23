//
//  IEDTO.swift
//  Seniority
//
//  Created by 이현주 on 8/23/25.
//

import Foundation

// MARK: - Request DTOs
struct IERequestDTO: Codable {
    let model: String
    let messages: [Message]
    let responseFormat: ResponseFormat

    enum CodingKeys: String, CodingKey {
        case model, messages
        case responseFormat = "response_format"
    }
}

struct Message: Codable {
    let role: String
    let content: [Content]
}

struct Content: Codable {
    let type: String
    let imageURL: ImageURL

    enum CodingKeys: String, CodingKey {
        case type
        case imageURL = "image_url"
    }
}

struct ImageURL: Codable {
    let url: String
}

struct ResponseFormat: Codable {
    let type: String
    let jsonSchema: JsonSchema

    enum CodingKeys: String, CodingKey {
        case type
        case jsonSchema = "json_schema"
    }
}

struct JsonSchema: Codable {
    let name: String
    let schema: Schema
}

struct Schema: Codable {
    let type: String
    let properties: Properties
}

struct Properties: Codable {
    let bankName: BankName

    enum CodingKeys: String, CodingKey {
        case bankName = "bank_name"
    }
}

struct BankName: Codable {
    let type: String
    let description: String
}

// MARK: - Response DTOs
struct IEResponseDTO: Codable {
    let id: String
    let choices: [Choice]
    let created: Int
    let model: String
    let usage: Usage
}

struct Choice: Codable {
    let message: MessageContent
    let finishReason: String
    let index: Int

    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
        case index
    }
}

struct MessageContent: Codable {
    let content: String
    let role: String
    let toolCalls: String?

    enum CodingKeys: String, CodingKey {
        case content, role
        case toolCalls = "tool_calls"
    }
}

struct Usage: Codable {
    let completionTokens: Int
    let promptTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case completionTokens = "completion_tokens"
        case promptTokens = "prompt_tokens"
        case totalTokens = "total_tokens"
    }
}
