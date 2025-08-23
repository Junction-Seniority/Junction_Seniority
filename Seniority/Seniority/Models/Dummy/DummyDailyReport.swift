//
//  DummyDailyReport.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

enum DummyDailyReport {
    static let sampleReports: [DailyReport] = [
        DailyReport(
            date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
            childId: "child-001",
            activities: [
                Activity(
                    name: "자유놀이",
                    description: "블록놀이와 역할놀이를 즐겁게 했습니다. 친구들과 잘 어울려 놀았어요.",
                    time: Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: Date())!,
                    participation: .excellent
                ),
                Activity(
                    name: "미술활동",
                    description: "색칠하기 활동을 했습니다. 집중력이 좋았어요.",
                    time: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
                    participation: .good
                ),
                Activity(
                    name: "음악시간",
                    description: "동요를 부르고 악기 연주를 했습니다. 리듬감이 좋아요!",
                    time: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date())!,
                    participation: .excellent
                )
            ],
            meals: [
                Meal(
                    type: .lunch,
                    items: ["밥", "미역국", "불고기", "김치", "사과"],
                    amount: .most,
                    notes: "불고기를 특히 좋아했어요"
                ),
                Meal(
                    type: .snack,
                    items: ["우유", "쿠키"],
                    amount: .all,
                    notes: nil
                )
            ],
            healthNotes: [
                HealthNote(
                    type: .temperature,
                    description: "36.5°C 정상",
                    time: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
                    severity: .normal
                ),
                HealthNote(
                    type: .mood,
                    description: "하루 종일 밝고 활발했어요",
                    severity: .normal
                )
            ],
            generalNotes: "오늘 하루 정말 잘 지냈어요! 친구들과도 잘 어울리고 활동 참여도 적극적이었습니다. 집에서도 오늘 있었던 일들을 많이 물어봐 주세요.",
            teacherName: "김선생님"
        ),
        
        DailyReport(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            childId: "child-001",
            activities: [
                Activity(
                    name: "체육활동",
                    description: "축구를 했습니다. 공을 차는 것을 좋아해요.",
                    time: Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!,
                    participation: .good
                ),
                Activity(
                    name: "동화시간",
                    description: "곰 세 마리 이야기를 들었습니다. 집중해서 잘 들었어요.",
                    time: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!,
                    participation: .excellent
                )
            ],
            meals: [
                Meal(
                    type: .breakfast,
                    items: ["토스트", "잼", "우유"],
                    amount: .half,
                    notes: "아침에 조금 기운이 없었어요"
                ),
                Meal(
                    type: .lunch,
                    items: ["카레라이스", "단무지", "요구르트"],
                    amount: .all,
                    notes: "카레를 아주 맛있게 먹었어요"
                )
            ],
            healthNotes: [
                HealthNote(
                    type: .sleep,
                    description: "낮잠을 1시간 30분 푹 잤어요",
                    time: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!,
                    severity: .normal
                )
            ],
            generalNotes: "어제보다 더 활발했어요. 특히 체육활동을 좋아하는 것 같습니다.",
            teacherName: "김선생님"
        ),
        
        DailyReport(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            childId: "child-001",
            activities: [
                Activity(
                    name: "과학실험",
                    description: "물과 기름 실험을 했습니다. 궁금해하며 열심히 관찰했어요.",
                    time: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)!,
                    participation: .excellent
                ),
                Activity(
                    name: "만들기",
                    description: "종이접기로 학을 만들었습니다. 조금 어려워했지만 끝까지 했어요.",
                    time: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)!,
                    participation: .moderate
                )
            ],
            meals: [
                Meal(
                    type: .lunch,
                    items: ["짜장면", "단무지", "우유"],
                    amount: .most,
                    notes: "짜장면을 아주 좋아해요"
                ),
                Meal(
                    type: .snack,
                    items: ["바나나", "물"],
                    amount: .all
                )
            ],
            healthNotes: [
                HealthNote(
                    type: .mood,
                    description: "오전에 조금 울었지만 금세 괜찮아졌어요",
                    severity: .attention
                ),
                HealthNote(
                    type: .toilet,
                    description: "화장실을 혼자서 잘 다녀왔어요",
                    severity: .normal
                )
            ],
            generalNotes: "새로운 것에 대한 호기심이 많아요. 과학실험에 특히 관심을 보였습니다.",
            teacherName: "김선생님"
        )
    ]
    
    static func getTodayReport() -> DailyReport? {
        return sampleReports.first { Calendar.current.isDateInToday($0.date) }
    }
    
    static func getReportsByDateRange(from startDate: Date, to endDate: Date) -> [DailyReport] {
        return sampleReports.filter { report in
            report.date >= startDate && report.date <= endDate
        }.sorted { $0.date > $1.date }
    }
    
    static func getLatestReports(count: Int = 7) -> [DailyReport] {
        return Array(sampleReports.sorted { $0.date > $1.date }.prefix(count))
    }
}
