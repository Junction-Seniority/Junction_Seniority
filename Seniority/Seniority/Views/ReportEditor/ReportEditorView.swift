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
                            
                            Text("✦ 알림장 끝에 각 원아별 특이사항이 기록될 예정이에요")
                                .body01_16Bold()
                                .foregroundColor(.prime100)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                
                            Button(action: {}) {
                                HStack {
                                    Spacer()
                                    Text("알림장 생성하기")
                                        .subHead01_20Bold()
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .background(.prime100)
                                .cornerRadius(12)
                            }
                            .padding(.bottom, 16)
                        }
                        .padding(.horizontal, 20)
                    }
                    .background(Color.prime40)
                }
            }
        }
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
