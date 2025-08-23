//
//  MainView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

struct ChildDummy: Identifiable {
    let id = UUID()
    var name: String
    var birth: Date
    var schedules: [String]
    var notes: [String]
}

/// 선생님 메인 뷰
struct MainView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    @State private var isLaunch: Bool = true
    
    @State private var children: [ChildDummy] = [
        ChildDummy(
            name: "정종문",
            birth: Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 3))!,
            schedules: [],
            notes: []
        ),
        ChildDummy(
            name: "김지혜",
            birth: Calendar.current.date(from: DateComponents(year: 2023, month: 3, day: 14))!,
            schedules: [],
            notes: []
        ),
        ChildDummy(
            name: "임서연",
            birth: Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 24))!,
            schedules: ["등원 후 목감기 약 복약"],
            notes: ["오늘 놀이터에서 뛰어다니다가 넘어지는 사건이 있었습니다", "간식을 반을 남겼습니다 요플레를 싫어하는 것 같아요"]
        ),
        
    ]
    
    var body: some View {
        if isLaunch {
            LaunchView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { withAnimation(.linear) {
                        self.isLaunch = false
                    }
                    }
                }
        } else {
            VStack(alignment: .center, spacing: 20) {
                
                HStack(alignment: .top) {
                    // Space Between
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
                .padding(.horizontal, 0)
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
                    HStack(alignment: .center, spacing: 10) {
                        Image(.union)
                            .foregroundColor(.white)
                    }
                    .padding(15)
                    .background(.prime100)
                    .cornerRadius(9999)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.prime40)
        }
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
                        HStack{
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
                                        draftNote.removeLast()   // 개행 제거
                                        commitNote()             // 곧장 등록
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
        if isJJM { child.notes = [] }   // 화면도 함께 초기화
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

#Preview {
    MainView()
        .environmentObject(AppCoordinator())
}
