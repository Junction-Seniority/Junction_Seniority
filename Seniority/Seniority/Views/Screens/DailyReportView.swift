//
//  DailyReportView.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct DailyReportView: View {
    @State private var selectedDate = Date()
    @State private var currentReport: DailyReport?
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 날짜 선택 섹션
                    DateSelectionView(
                        selectedDate: $selectedDate,
                        showDatePicker: $showDatePicker
                    )
                    
                    if let report = currentReport {
                        // 알림장 내용
                        DailyReportContentView(report: report)
                    } else {
                        // 빈 상태
                        EmptyReportView()
                    }
                }
                .padding()
            }
            .navigationTitle("알림장")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadReportForDate()
            }
            .onChange(of: selectedDate) { _ in
                loadReportForDate()
            }
        }
    }
    
    private func loadReportForDate() {
        // 더미 데이터에서 선택된 날짜에 해당하는 알림장 찾기
        currentReport = DummyDailyReport.sampleReports.first { report in
            Calendar.current.isDate(report.date, inSameDayAs: selectedDate)
        }
    }
}

struct DateSelectionView: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("날짜 선택")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    HStack(spacing: 4) {
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.subheadline)
                        Image(systemName: "calendar")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
            
            if showDatePicker {
                DatePicker(
                    "날짜 선택",
                    selection: $selectedDate,
                    in: Calendar.current.date(byAdding: .month, value: -3, to: Date())! ... Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: selectedDate) { _ in
                    showDatePicker = false
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DailyReportContentView: View {
    let report: DailyReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 선생님 정보
            TeacherInfoView(teacherName: report.teacherName)
            
            // 활동 내역
            if !report.activities.isEmpty {
                ActivitySectionView(activities: report.activities)
            }
            
            // 식사 내역
            if !report.meals.isEmpty {
                MealSectionView(meals: report.meals)
            }
            
            // 건강 상태
            if !report.healthNotes.isEmpty {
                HealthSectionView(healthNotes: report.healthNotes)
            }
            
            // 전체 소감
            if let generalNotes = report.generalNotes {
                GeneralNotesView(notes: generalNotes)
            }
        }
    }
}

struct TeacherInfoView: View {
    let teacherName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("담당 선생님")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text(teacherName)
                    .font(.body)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct ActivitySectionView: View {
    let activities: [Activity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("활동 내역")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(activities, id: \.id) { activity in
                ActivityItemView(activity: activity, activities: activities)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct ActivityItemView: View {
    let activity: Activity
    let activities: [Activity]
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(activity.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text(activity.participation.emoji)
                    Text(activity.participation.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(timeFormatter.string(from: activity.time))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(activity.description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 8)
        
        if activity.id != activities.last?.id {
            Divider()
        }
    }
}

struct MealSectionView: View {
    let meals: [Meal]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("식사 내역")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(meals, id: \.id) { meal in
                MealItemView(meal: meal, meals: meals)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct MealItemView: View {
    let meal: Meal
    let meals: [Meal]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 4) {
                    Text(meal.type.icon)
                    Text(meal.type.displayName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text(meal.amount.emoji)
                    Text(meal.amount.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(meal.items.joined(separator: ", "))
                .font(.body)
                .foregroundColor(.secondary)
            
            if let notes = meal.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .italic()
            }
        }
        .padding(.vertical, 8)
        
        if meal.id != meals.last?.id {
            Divider()
        }
    }
}

struct HealthSectionView: View {
    let healthNotes: [HealthNote]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("건강 상태")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(healthNotes, id: \.id) { note in
                HealthItemView(healthNote: note, healthNotes: healthNotes)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct HealthItemView: View {
    let healthNote: HealthNote
    let healthNotes: [HealthNote]
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Text(healthNote.type.icon)
                Text(healthNote.type.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(healthNote.description)
                    .font(.body)
                    .multilineTextAlignment(.trailing)
                
                Text(healthNote.severity.displayName)
                    .font(.caption)
                    .foregroundColor(colorForSeverity(healthNote.severity))
            }
        }
        .padding(.vertical, 8)
        
        if healthNote.id != healthNotes.last?.id {
            Divider()
        }
    }
    
    private func colorForSeverity(_ severity: Severity) -> Color {
        switch severity {
        case .normal:
            return .green
        case .attention:
            return .orange
        case .concern:
            return .red
        }
    }
}

struct GeneralNotesView: View {
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘의 전체 소감")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(notes)
                .font(.body)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct EmptyReportView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("해당 날짜의 알림장이 없습니다")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("다른 날짜를 선택해주세요")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    DailyReportView()
}
