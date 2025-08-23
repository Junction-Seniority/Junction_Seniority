//
//  APIClient.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

protocol APIClientProtocol {
    func sendChatRequest(_ request: ChatRequestDTO) async throws -> ChatResponseDTO
    func sendIERequest(_ request: IERequestDTO) async throws -> IEResponseDTO
}

class APIClient: APIClientProtocol {
    
    private let session: URLSession
    private let chatURL = "https://api.upstage.ai/v1/chat/completions"
    private let ieURL = "https://api.upstage.ai/v1/information-extraction"
    private let apiKey = "up_BCFydbHTtkRMyrsRRmW1UOEUxGzfs"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func sendChatRequest(_ request: ChatRequestDTO) async throws -> ChatResponseDTO {
        guard let url = URL(string: chatURL) else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
        } catch {
            throw APIError.encodingFailed(error)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.httpError(httpResponse.statusCode)
            }
            
            // Debug logging
            #if DEBUG
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(rawString)")
            }
            #endif
            
            do {
                let responseDTO = try JSONDecoder().decode(ChatResponseDTO.self, from: data)
                return responseDTO
            } catch {
                throw APIError.decodingFailed(error)
            }
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func sendIERequest(_ request: IERequestDTO) async throws -> IEResponseDTO {
        guard let url = URL(string: ieURL) else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
        } catch {
            throw APIError.encodingFailed(error)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.httpError(httpResponse.statusCode)
            }
            
            // Debug logging
            #if DEBUG
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(rawString)")
            }
            #endif
            
            do {
                let responseDTO = try JSONDecoder().decode(IEResponseDTO.self, from: data)
                return responseDTO
            } catch {
                throw APIError.decodingFailed(error)
            }
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
