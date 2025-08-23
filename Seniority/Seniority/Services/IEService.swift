//
//  IEService.swift
//  Seniority
//
//  Created by 이현주 on 8/23/25.
//

import Foundation

// MARK: - IE Service Protocol
protocol IEServiceProtocol {
    func extractInformation(from request: IERequestDTO) async throws -> IEResponseDTO
}

// MARK: - IE Service
class IEService: IEServiceProtocol {
    private let apiClient: APIClientProtocol
    private let mapper: IEMapperProtocol
    
    init(apiClient: APIClientProtocol = APIClient(), mapper: IEMapperProtocol = IEMapper()) {
        self.apiClient = apiClient
        self.mapper = mapper
    }
    
    func extractInformation(from request: IERequestDTO) async throws -> IEResponse {
        let responseDTO = try await apiClient.sendIERequest(request)
        return mapper.toDomainModel(from: responseDTO)
    }
}

protocol IEMapperProtocol {
    func toDomainModel(from dto: IEResponseDTO) -> IEResponse
}

class IEMapper: IEMapperProtocol {
    func toDomainModel(from dto: IEResponseDTO) -> IEResponse {
        // IEResponseDTO → 앱 내부에서 쓰기 편한 Domain Model로 변환
        return IEResponse(
            id: dto.id,
            content: extractContent(from: dto),
            model: dto.model,
            usage: dto.usage.map {
                TokenUsage(
                    promptTokens: $0.prompt_tokens,
                    completionTokens: $0.completion_tokens,
                    totalTokens: $0.total_tokens
                )
            }
        )
    }
    
    private func extractContent(from dto: IEResponseDTO) -> String {
        guard let firstChoice = dto.choices.first else { return "" }
        return firstChoice.message.content
    }
}

