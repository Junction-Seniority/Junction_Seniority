//
//  ReportEditorView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

/// 선생님 알림장 작성 뷰
struct ReportEditorView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var report = DummyReportEdit
    
    @State private var additionalNotes = ""
    @State private var isAddingSupplies = false
    
    @State private var isGenerating = false
    @State private var generatedReport: String? = nil
    @State private var showError = false
    @State private var errorMessage = ""
    
    @AppStorage("savedReportData") private var savedReportData: Data = .init()
    @State private var showSaveSuccess = false
    
    // 서비스
    private let chatService = ChatService()
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomNavigationBar(
                    title: "알림장 작성"
                )
                VStack {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16, pinnedViews: []) {
                            // Header Section
                            VStack(spacing: 8) {
                                HStack {
                                    Text("받는사람")
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Text("해바라기반 전체")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("전송시간")
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Text("2025년 8월 22일 오후 5시")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
                            
                            // 날씨 및 인사말 Category
                            VStack(alignment: .leading, spacing: 8) {
                                Text("날씨 및 인사말")
                                    .body01_16Bold()
                                
                                HStack(spacing: 8) {
                                    ForEach(GreetingStyle.allCases, id: \.self) { style in
                                        Button(action: {
                                            report.greetingStyle = style
                                        }) {
                                            Text(style.rawValue)
                                                .body03_14Light()
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 10)
                                                .background(
                                                    report.greetingStyle == style ?
                                                        .prime90 :
                                                        .white
                                                )
                                                .foregroundColor(
                                                    .black70
                                                )
                                                .cornerRadius(20)
                                                .overlay(
                                                    report.greetingStyle != style ?
                                                        RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.prime90, lineWidth: 1)
                                                        .opacity(0.7)
                                                        : nil
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
                            
                            // 오늘 활동 Category
                            VStack(alignment: .leading, spacing: 8) {
                                Text("오늘 활동")
                                    .body01_16Bold()
                                
                                ForEach(report.activities, id: \.self) { activity in
                                    Text(activity.title)
                                        .body02_16Regular()
                                    Text(activity.content)
                                        .body03_14Light()
                                        .foregroundStyle(.black70)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
                            
                            // 식사 내역 Category
                            VStack(alignment: .leading, spacing: 8) {
                                Text("식사 내역")
                                    .body01_16Bold()
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("점심")
                                        .body02_16Regular()
                                    HStack {
                                        ForEach(report.mealInfo.lunchMenu, id: \.self) { item in
                                            Text(item)
                                                .body03_14Light()
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("간식")
                                        .body02_16Regular()
                                    HStack {
                                        ForEach(report.mealInfo.snackMenu, id: \.self) { item in
                                            Text(item)
                                                .body03_14Light()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
                            
                            // 행사 및 준비물 Category
                            VStack(alignment: .leading, spacing: 8) {
                                Text("행사 및 준비물")
                                    .body01_16Bold()
                                
                                Text(report.event?.date ?? "8.25(월)")
                                    .body02_16Regular()
                                
                                Text(report.event?.title ?? "")
                                    .body03_14Light()
                                
                                if let event = report.event, let supplies = event.supplies, !supplies.isEmpty {
                                    // 이미 준비물이 있으면 바로 텍스트 필드를 표시
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("준비물")
                                            .body02_16Regular()
                                        
                                        TextField("필요한 준비물이 있다면 작성해주세요", text: Binding<String>(
                                            get: { report.event?.supplies ?? "" },
                                            set: { newValue in
                                                if report.event != nil {
                                                    report.event?.supplies = newValue.isEmpty ? nil : newValue
                                                }
                                            }
                                        ), axis: .vertical)
                                            .font(.system(size: 14))
                                            .cornerRadius(8)
                                            .lineLimit(2 ... 4)
                                    }
                                } else {
                                    // 준비물이 없으면 추가하기 버튼과 텍스트 필드를 조건부로 표시
                                    HStack {
                                        Text("준비물")
                                            .body02_16Regular()
                                        Spacer()
                                        Button(action: {
                                            isAddingSupplies = true
                                        }) {
                                            Text("추가하기")
                                                .body03_14Light()
                                                .padding(.horizontal, 8.5)
                                                .padding(.vertical, 1.5)
                                                .background(
                                                    Capsule()
                                                        .fill(Color.prime90)
                                                )
                                                .foregroundStyle(.black70)
                                        }
                                        .opacity(isAddingSupplies ? 0 : 1)
                                    }
                                    
                                    if isAddingSupplies {
                                        TextField("필요한 준비물이 있다면 작성해주세요", text: Binding<String>(
                                            get: { report.event?.supplies ?? "" },
                                            set: { newValue in
                                                if report.event != nil {
                                                    report.event?.supplies = newValue.isEmpty ? nil : newValue
                                                }
                                            }
                                        ), axis: .vertical)
                                            .font(.system(size: 14))
                                            .cornerRadius(8)
                                            .lineLimit(2 ... 4)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
                            
                            // 추가 전달 사항 Category
                            VStack(alignment: .leading, spacing: 8) {
                                Text("추가 전달 사항")
                                    .body01_16Bold()
                                
                                TextField("추가로 학부모님께 공통적으로 전달할 내용이 있다면 간략히 적어주세요", text: $additionalNotes, axis: .vertical)
                                    .font(.system(size: 14))
                                    .cornerRadius(8)
                                    .lineLimit(3 ... 6)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
                            
                            // 마무리 인사말 Category
                            VStack(alignment: .leading, spacing: 8) {
                                Text("마무리 인삿말")
                                    .body01_16Bold()
                                
                                HStack(spacing: 8) {
                                    ForEach(ClosingGreetingStyle.allCases, id: \.self) { style in
                                        Button(action: {
                                            report.closingGreetingStyle = style
                                        }) {
                                            Text(style.rawValue)
                                                .body03_14Light()
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 10)
                                                .background(
                                                    report.closingGreetingStyle == style ?
                                                        .prime90 :
                                                        .white
                                                )
                                                .foregroundColor(
                                                    report.closingGreetingStyle == style ? .white : .black70
                                                )
                                                .cornerRadius(20)
                                                .overlay(
                                                    report.closingGreetingStyle != style ?
                                                        RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.prime90, lineWidth: 1)
                                                        .opacity(0.7)
                                                        : nil
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
                            
                            HStack(spacing: 10) {
                                Image(.point)
                                Text("알림장 끝에 각 원아별 특이사항이 기록될 예정이에요")
                                    .body01_16Bold()
                                    .foregroundColor(.prime100)
                                    .frame(maxWidth: .infinity)
                                    .lineLimit(1)
                            }
                            .padding(.top, 32)
                            .padding(.bottom, 16)
                            
                            Button(action: {
                                Task {
                                    await generateReport()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    if isGenerating {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        Text("생성 중...")
                                            .subHead01_20Bold()
                                            .foregroundColor(.white)
                                    } else {
                                        Text("알림장 생성하기")
                                            .subHead01_20Bold()
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .background(isGenerating ? .gray : .prime100)
                                .cornerRadius(12)
                            }
                            .disabled(isGenerating)
                            .alert("오류", isPresented: $showError) {
                                Button("확인", role: .cancel) {}
                            } message: {
                                Text(errorMessage)
                            }
                            .padding(.bottom, 16)
                            
                            // 저장 성공 메시지
                            if showSaveSuccess {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("알림장이 저장되었습니다!")
                                        .body02_16Regular()
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                                .transition(.opacity)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .background(Color.prime40)
                }
            }
        }
    }
    
    // MARK: - AI 알림장 생성 기능

    @MainActor
    private func generateReport() async {
        isGenerating = true
        defer {
            isGenerating = false
        }
        
        do {
            let prompt = buildPrompt()
            let response = try await chatService.sendMessage(prompt, model: .solarPro2)
            generatedReport = response.content
            
            // 생성 성공하면 자동으로 저장
            if !response.content.isEmpty {
                saveReport(content: response.content)
            }
            
        } catch {
            errorMessage = "알림장 생성 중 오류가 발생했습니다: \(error.localizedDescription)"
            showError = true
        }
    }
    
    private func buildPrompt() -> String {
        // 첫 번째 아이 정보 가져오기
        let firstChild = DummyChild.children.first
        
        // 날짜 포맷팅
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let todayString = dateFormatter.string(from: Date())
        
        // 나이 계산
        func calculateAge(from birth: Date) -> String {
            let components = Calendar.current.dateComponents([.month], from: birth, to: Date())
            return "생후 \(components.month ?? 0)개월"
        }
        
        var prompt = """
        당신은 관찰력이 뛰어나고 사실에 기반하여 소통하는 전문 유치원 교사입니다. 다음 정보와 **매우 엄격한 스타일 가이드**를 바탕으로, 학부모님께 보낼 알림장을 작성해야 합니다.

        ---

        ## ⚠️ **매우 중요한 원칙 (반드시 지켜주세요)**

        1.  ****절대 금지**: 제공된 '[오늘의 정보]'에 없는 내용을 상상하거나 꾸며내지 마세요. (No Lying, No Exaggeration, No Fabrication)
        2.  **사실 기반**: 아이의 말과 행동은 '[오늘의 정보]'의 '특이사항'에 명시된 경우에만 인용하세요.
        3.  **간결함**: 정보가 부족하다면 억지로 내용을 늘리지 마세요. 짧고 담백하게 작성하는 것이 좋습니다.
        4.  **객관적 서술**: 활동 내용을 서술할 때, 추상적인 표현(예: '음악 활동')을 구체적인 행동인 것처럼 부풀리지 마세요. '음악에 맞춰 율동하는 시간을 가졌습니다' 와 같이 활동 자체에 대해서만 간결히 전달하세요.
        5.  **음식 / 간식 언급**: 식사 / 간식 메뉴는 특별히 언급되거나, 아이의 정보에 연관되어있지않는 한 굳이 언급하지마세요. 아이의 식사량이나 태도에 대한 언급은 '특이사항'에 관련된 내용이 있을 때만 추가하세요.

        ---

        ##  유치원 알림장 스타일 가이드

        ### 1. 기본 구조
        - **인사말**: "안녕하세요 [아이 이름] 어머니!" 로 시작합니다. (성은 붙이지 마세요)
        - **핵심 관찰 내용**: 오늘 있었던 아이의 긍정적인 행동이나 성장에 대한 내용을 중심으로 작성합니다.
        - **세부 내용**: 오늘의 활동, 식사 등 정보를 자연스럽게 연결합니다.
        - **마무리**: 격려와 응원의 메시지로 마무리합니다.

        ### 2. 문체 및 표현
        - **어미**: "~랍니다", "~했어요", "~였습니다" 등 부드러운 종결어미를 사용해주세요.
        - **호칭**: 아이의 이름은 성을 제외하고 "OO이가", "OO는" 와 같이 불러주세요.
        - **긍정적 표현**: 어려운 점이 있었다면, 성장의 과정으로 표현해주세요.
        - **감정 표현**: "대견한 마음이 들었답니다" 와 같은 감정 표현은, 반드시 '[오늘의 정보]'에 근거가 있을 때만 사용하세요.

        ---

        ## [오늘의 정보]

        **기본 정보**
        - 날짜: \(todayString)
        - 반 이름: 해바라기반 (만 3세)
        - 받는 사람: 대상 학생의 어머님
        - 전송 시간: 2025년 8월 22일 오후 5시

        **날씨 및 인사말 스타일**: \(report.greetingStyle.rawValue)

        **오늘의 활동**
        """
            
        // 활동 내역 추가
        for activity in report.activities {
            prompt += "\n- \(activity.title): \(activity.content)"
        }
            
        prompt += "\n\n**식사 내역**"
        prompt += "\n- 점심: \(report.mealInfo.lunchMenu.joined(separator: ", "))"
        prompt += "\n- 간식: \(report.mealInfo.snackMenu.joined(separator: ", "))"
            
        // 행사 및 준비물
        if let event = report.event {
            prompt += "\n\n**행사 및 준비물**"
            prompt += "\n- 일정: \(event.date)"
            prompt += "\n- 내용: \(event.title)"
            if let supplies = event.supplies, !supplies.isEmpty {
                prompt += "\n- 준비물: \(supplies)"
            }
        }
            
        // 추가 전달사항
        if !additionalNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            prompt += "\n\n**추가 전달사항**\n\(additionalNotes)"
        }
            
        // 마무리 인사말
        prompt += "\n\n**마무리 인사말 스타일**: \(report.closingGreetingStyle.rawValue)"
            
        // 아이 정보 (첫 번째 아이)
        if let child = firstChild {
            prompt += "\n\n**대표 원아 정보**"
            prompt += "\n- 이름: \(child.name)"
            prompt += "\n- 나이: \(calculateAge(from: child.birth))"
                
            if !child.schedules.isEmpty {
                prompt += "\n- 오늘 특별 스케줄: \(child.schedules.joined(separator: ", "))"
            }
                
            if !child.notes.isEmpty {
                prompt += "\n- 오늘 \(child.name)이의 특이사항:"
                for note in child.notes {
                    prompt += "\n  • \(note)"
                }
            }
        }
            
        prompt += """

        ---

        ## [작성 요청사항]

        1.  위의 **'매우 중요한 원칙'**을 반드시 지켜서, 사실에만 근거한 알림장을 작성해주세요.
        2.  \(firstChild?.name ?? "아이")의 '특이사항'이 있다면 그 내용을 중심으로 개별화된 내용을 작성하고, 없다면 전반적인 활동에 대해 담백하게 서술해주세요.
        3.  모든 정보를 자연스럽게 연결하여 실제 유치원 선생님이 보낸 것처럼 완성된 하나의 글로 만들어주세요.
        """
        
        return prompt
    }
    
    // MARK: - 간단한 저장 기능 (AppStorage)
    
    private func saveReport(content: String) {
        // 현재 화면에 표시된 정보로 저장
        let savedReport = SavedReport(
            responseText: content,
            recipient: "해바라기반 전체",
            sendTimeString: "2025년 8월 22일 오후 5시"
        )
        
        // AppStorage에 저장
        if let encoded = try? JSONEncoder().encode(savedReport) {
            savedReportData = encoded
            
            // 저장 성공 표시
            showSaveSuccess = true
            
            // 3초 후 성공 메시지 숨기기
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showSaveSuccess = false
            }
        }
    }
    
    // 저장된 알림장 불러오기 (옵셔널)
    private var savedReport: SavedReport? {
        guard !savedReportData.isEmpty,
              let saved = try? JSONDecoder().decode(SavedReport.self, from: savedReportData)
        else {
            return nil
        }
        return saved
    }
}

#Preview {
    ZStack {
        Color.prime40
        VStack {
            CustomNavigationBar(
                title: "알림장 작성"
            )
            ReportEditorView()
        }
    }
    .ignoresSafeArea()
}
