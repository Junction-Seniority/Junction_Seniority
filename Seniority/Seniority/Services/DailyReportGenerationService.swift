//
//  DailyReportGenerationService.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

protocol DailyReportGenerationServiceProtocol {
    func generateDailyReport(keywords: String, child: Child) async throws -> String
}

class DailyReportGenerationService: DailyReportGenerationServiceProtocol {
    private let chatService: ChatServiceProtocol
    private let styleGuide: String
    
    init(chatService: ChatServiceProtocol = ChatService()) {
        self.chatService = chatService
        self.styleGuide = Self.getStyleGuide()
    }
    
    func generateDailyReport(keywords: String, child: Child) async throws -> String {
        let prompt = buildPrompt(keywords: keywords, child: child)
        
        // Create a combined message with system prompt and user keywords
        let fullMessage = """
        \(prompt)
        
        키워드: \(keywords)
        """
        
        let response = try await chatService.sendMessage(fullMessage, model: .solarPro2)
        return response.content
    }
    
    private func buildPrompt(keywords: String, child: Child) -> String {
        return """
        당신은 유치원 선생님입니다. 다음 정보를 바탕으로 알림장을 작성해주세요.
        
        ## 아이 정보
        - 이름: \(child.name)
        - 나이: \(child.age)세
        - 특성: \(child.traits.joined(separator: ", "))
        - 알레르기: \(child.cautions.allergies.isEmpty ? "없음" : child.cautions.allergies.joined(separator: ", "))
        - 환경 주의사항: \(child.cautions.environment.isEmpty ? "없음" : child.cautions.environment.joined(separator: ", "))
        - 질병: \(child.cautions.diseases.isEmpty ? "없음" : child.cautions.diseases.joined(separator: ", "))
        
        ## 작성 스타일 가이드
        \(styleGuide)
        
        ## 요청사항
        - 제공된 키워드를 바탕으로 하루 일과에 대한 자연스러운 알림장을 작성해주세요
        - 아이의 부모에게 전달하는 것임을 확실하게 인지하세요.
        - 아이의 특성과 주의사항을 자연스럽게 반영해주세요
        - 절대로 없는 이야기를 억지로 만드려고 하지마세요.
        - 특이사항에 대해서는 언급하지않았다면 굳이 언급하려고 억지 스토리를 만들어내지 않아야합니다.
        - 그게 아니라면 아예 언급을 하지 마세요.
        - 스타일 가이드의 문체와 표현 패턴을 따라주세요
        - 구체적인 상황과 에피소드를 포함해주세요
        - 긍정적이고 따뜻한 어조로 작성해주세요
        """
    }
    
    private static func getStyleGuide() -> String {
        return """
        📝 기본 구조: 인사말 → 핵심 내용 → 구체적 에피소드 → 긍정적 마무리
        
        💬 문체: "~답니다", "~었어요", "~했답니다" 등 따뜻하고 부드러운 어조
        감정 표현: "감동받았답니다", "대견한 마음이 듭니다", "얼마나 뿌듯했던지"
        
        🎯 핵심 패턴:
        - 아이 말 직접 인용: "선생님, 저 왔어요!"
        - 행동 묘사: "어깨를 으쓱하고", "먼저 다가와 안기기도"  
        - 긍정적 프레이밍: 어려움도 성장으로 표현
        - 협력적 관계: "부모님께서도 응원해주세요"
        """
    }
}

struct DailyReportGenerationRequest {
    let keywords: String
    let child: Child
    let date: Date
    
    init(keywords: String, child: Child, date: Date = Date()) {
        self.keywords = keywords
        self.child = child
        self.date = date
    }
}
