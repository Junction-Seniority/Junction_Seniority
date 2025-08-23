//
//  UpstageAPIService.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

class UpstageAPIService: ObservableObject {
    private let apiKey = "up_BCFydbHTtkRMyrsRRmW1UOEUxGzfs"
    private let baseURL = "https://api.upstage.ai/v1/chat/completions"
    
    @Published var isLoading = false
    @Published var response = ""
    @Published var errorMessage = ""
    
    struct ChatRequest: Codable {
        let model: String
        let messages: [Message]
        let reasoning_effort: String
        let stream: Bool
        
        struct Message: Codable {
            let role: String
            let content: String
        }
    }
    
    struct ChatResponse: Codable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let choices: [Choice]
        
        struct Choice: Codable {
            let index: Int
            let message: Message?
            let delta: Delta?
            let finish_reason: String?
            
            struct Message: Codable {
                let role: String
                let content: String
            }
            
            struct Delta: Codable {
                let role: String?
                let content: String?
            }
        }
    }
}
