//
//  FileUploadView.swift
//  Seniority
//
//  Created by J on 8/23/25.
//

import SwiftUI

/// 파일 업로드 뷰
struct FileUploadView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("업로드 한 번으로\n알림장이 알아서 잘 딱! 완성됩니다")
                    .head01_24Bold()
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                
                Text("선생님의 시간을 아끼고 아이들에게 집중하세요!")
                    .body03_14Light()
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .center, spacing: 32) {
                VStack(alignment: .leading) {
                    Text("데이터 학습")
                        .head01_24Bold()
                        .foregroundColor(.primeDark)
                    
                    HStack(alignment: .center, spacing: 20) {
                        RegisterFileCardView(title: "원생정보", description: "아이들 각각의 특성에 맞는\n알림장 생성이 가능해요")
                        RegisterFileCardView(title: "알림장 학습", description: "선생님들의 말투를 학습해\n 자연스러운 알림장이 생성돼요")
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("이달의 통신문 등록")
                        .head01_24Bold()
                        .foregroundColor(.primeDark)
                    
                    HStack(alignment: .center, spacing: 20) {
                        RegisterFileCardView(title: "행사 정보", description: "원의 행사를 미리 등록해\n알림장에 반영할 수 있어요")
                        RegisterFileCardView(title: "급식 정보", description: "급식표 업로드로 직접\n메뉴를 업로드 할 필요가 없어요")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 32)
            .padding(.bottom, 16)
            
            VStack(alignment: .center, spacing: 16) {
                Button {
                    coordinator.popToRoot()
                } label: {
                    // Head/SubHead01-20Bold
                    HStack {
                        Text("시작하기")
                            .subHead01_20Bold()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(.prime100)
                    .cornerRadius(12)
                }
                
                Button {
                    coordinator.popToRoot()
                } label: {
                    // Caption/Caption01_12Light
                    Text("나중에 할게요")
                        .caption01_12Light()
                        .underline(true, pattern: .solid)
                        .foregroundColor(.black70)
                }
            }
            .padding(.vertical, 16)
            
            
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.prime40)
        
    }
}

struct RegisterFileCardView: View {
    
    @State var isUploaded: Bool = false
    
    var title: String
    var description: String
    
    var body: some View {
        Button {
            isUploaded.toggle()
        } label: {
            VStack(alignment: .center, spacing: 10) {
                Image(isUploaded ? .check : .upload)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .body01_16Bold()
                    .foregroundColor(.black)
                
                Text(description)
                    .caption01_12Light()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black70)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 8)
            .frame(width: 171, height: 171, alignment: .center)
            .background(isUploaded ? .prime90 : .prime60)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 1)
                    .stroke(.prime90, style: StrokeStyle(lineWidth: 2, dash: [8, 8]))
            )
        }
    }
}

#Preview {
    FileUploadView()
        .environmentObject(AppCoordinator())
}
