//
//  MainView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

/// 선생님 메인 뷰
struct MainView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var children = DummyChild.children
    
    @State private var showAlert: Bool = false
    
    var body: some View {

        ZStack {
            VStack(alignment: .center, spacing: 20) {

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("지혜 어린이집")
                            .head01_24Bold()
                            .foregroundColor(.primeDark)
                        Text("현주반 (만 3세) 총 4명")
                            .body02_16Regular()
                            .foregroundColor(.black70)
                    }

                    Spacer()

                    HStack {
                        Button("파일 업로드 뷰") {
                            coordinator.push(.fileUpload)
                        }
                        Button {
                            coordinator.push(.report)
                        } label: {
                            Image(.settings)
                        }
                    }
                }

                .padding(.vertical, 32)

                Text(todayString)
                    .body03_14Light()

                VStack {
                    ForEach($children) { $child in
                        ChildCardView(child: $child)
                    }
                }

                Spacer()

                Button {
                     coordinator.push(.reportEdit)
                } label: {
                    HStack(spacing: 10) {
                        Image(.union).foregroundColor(.white)
                    }
                    .padding(15)
                    .background(.prime100)
                    .cornerRadius(9999)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.prime40)
            .ignoresSafeArea(edges: .bottom)

            // ===== 오버레이 모달 =====
            if showAlert {
                // 딤 영역
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {                         // 배경 탭으로 닫기
                        withAnimation(.easeOut(duration: 0.2)) { showAlert = false }
                    }
                    .zIndex(1)

                // 모달 카드
                AlertModal(onConfirm: {
                    showAlert = false
                })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: showAlert) // 상태 애니메이션
    }
    
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
}

struct ChildCardView: View {
    @AppStorage("jjm_notes") private var jjmNotesJSON: String = "[]" // MARK: - 종문 어린이 특이사항만 AppStorage에 저장

    @Binding var child: ChildDummy
    
    @State private var isAddingNote: Bool = false
    @State private var draftNote: String = ""
    @FocusState private var noteFieldFocused: Bool
    
    // 이름으로 식별 (실서비스에선 id 기반 권장)
    private var isJJM: Bool { child.name == "정종문" }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 14) {
                Image((child.notes.isEmpty && child.schedules.isEmpty) ? .profileNone : .profile)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {
                        Text(child.name)
                            .body01_16Bold()
                        
                        Text("\(dateString(child.birth)) \(ageText(from: child.birth))")
                            .body03_14Light()
                        
                        Spacer()
                        
                        Button {
                            isAddingNote = true
                            draftNote = ""
                            DispatchQueue.main.async {
                                noteFieldFocused = true
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 10) {
                                Text("+ 추가하기")
                                    .body03_14Light()
                                    .foregroundColor(.black70)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 1)
                            .frame(height: 24, alignment: .center)
                            .background(Color(red: 0.59, green: 0.73, blue: 0.88))
                            .cornerRadius(999999)
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        ForEach(child.schedules, id: \.self) { schedule in
                            InfoTagView(schedule: schedule)
                        }
                    }
                }
                .padding(0)
                .frame(width: 265, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if child.notes.isEmpty && !isAddingNote {
                Text("아직 추가된 특이사항이 없어요")
                    .body03_14Light()
                    .foregroundColor(.black50)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(child.notes, id: \.self) { note in
                        HStack {
                            Text("✦")
                                .foregroundColor(.prime100)
                            Text(note)
                                .body03_14Light()
                        }
                    }
                    
                    if isAddingNote {
                        HStack {
                            Text("✦")
                                .foregroundColor(.prime100)
                            
                            TextField("특이사항을 입력하세요", text: $draftNote, axis: .vertical)
                                .font(
                                    Font.custom("Pretendard", size: 14)
                                        .weight(.light)
                                )
                                .submitLabel(.done)
                                .focused($noteFieldFocused)
                                .onSubmit { commitNote() }
                                .onChange(of: draftNote) { _, newValue in
                                    if newValue.last == "\n" {
                                        draftNote.removeLast() // 개행 제거
                                        commitNote() // 곧장 등록
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            // MARK: - 디버깅용

            Button("저장 초기화") { clearJJMNotes() }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .cornerRadius(12)
        // 마운트 시: 정종문이면 AppStorage → 메모리 로드
        .onAppear {
            if isJJM {
                let stored = decodeNotes(jjmNotesJSON)
                if !stored.isEmpty { child.notes = stored }
            }
        }
        .onChange(of: child.notes) { _, newValue in
            if isJJM { jjmNotesJSON = encodeNotes(newValue) }
        }
        .onChange(of: jjmNotesJSON) { _, newJSON in
            if isJJM { child.notes = decodeNotes(newJSON) }
        }
        .onChange(of: child.name) { _, _ in
            if isJJM {
                let stored = decodeNotes(jjmNotesJSON)
                if !stored.isEmpty { child.notes = stored }
            }
        }
    }
    
    // MARK: - Actions

    private func commitNote() {
        let trimmed = draftNote.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { cancelNote(); return }
        child.notes.append(trimmed)
        draftNote = ""
        isAddingNote = false
        noteFieldFocused = false
    }
    
    private func cancelNote() {
        draftNote = ""
        isAddingNote = false
        noteFieldFocused = false
    }
    
    // 날짜 포맷
    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yy.MM.dd"
        return f.string(from: date)
    }
    
    private func ageText(from birth: Date) -> String {
        let comps = Calendar.current.dateComponents([.month], from: birth, to: Date())
        return "생후 \(comps.month ?? 0)개월"
    }
    
    // MARK: - JSON Helpers

    private func encodeNotes(_ notes: [String]) -> String {
        (try? String(data: JSONEncoder().encode(notes), encoding: .utf8)) ?? "[]"
    }
    
    private func decodeNotes(_ json: String) -> [String] {
        guard let data = json.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
    
    private func clearJJMNotes() {
        jjmNotesJSON = "[]"
        if isJJM { child.notes = [] } // 화면도 함께 초기화
    }
}

struct InfoTagView: View {
    let schedule: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(schedule)
                .caption01_12Light()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 1)
        .frame(height: 24, alignment: .center)
        .background(Color(red: 0.92, green: 0.95, blue: 0.98))
        .cornerRadius(999)
        .overlay(
            RoundedRectangle(cornerRadius: 999)
                .inset(by: 0.5)
                .stroke(Color(red: 0.68, green: 0.78, blue: 0.9), lineWidth: 1)
        )
    }
}

struct AlertModal: View {
    var onConfirm: (() -> Void)
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 4) {
                Text("✦")
                    .body03_14Light()
                    .foregroundColor(.prime100)
                
                Text("오늘의 알잘딸깍쌤 완료")
                    .head01_24Bold()
                    .foregroundColor(.prime100)
                
                Text("선생님의 따뜻한 마음이 알림장에 담겼습니다")
                    .body03_14Light()
                    .foregroundColor(.black70)
            }
            
            Button {
                onConfirm()
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Text("확인")
                        .body01_16Bold()
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
            .background(Color(red: 0.38, green: 0.6, blue: 0.85))

            .cornerRadius(12)
        }
        .padding(24)
        .frame(width: 330, alignment: .top)
        .background(.white)
        .cornerRadius(12)
    }
}

#Preview {
    MainView()
        .environmentObject(AppCoordinator())
}
