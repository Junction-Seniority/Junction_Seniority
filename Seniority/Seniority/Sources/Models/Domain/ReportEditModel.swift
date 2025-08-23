import Foundation

enum GreetingStyle: String, CaseIterable {
    case basic = "기본"
    case weather = "날씨"
    case wellbeing = "안부"
    case family = "가정의 안녕"
    case holiday = "가까운 명절"
}

enum ClosingGreetingStyle: String, CaseIterable {
    case basic = "기본"
    case health = "건강"
    case weather = "날씨"
    case mindfulness = "마음챙김"
}

// 이벤트 정보를 담는 구조체
struct PlannedEvent {
    var title: String
    var date: String
    var supplies: [String]
}

// 식사 정보를 담는 구조체
struct MealInfo {
    var lunchMenu: [String]
    var snackMenu: [String]
}

// 이미지의 알림장 전체 데이터를 담는 모델
struct SimpleDailyReport: Identifiable {
    let id = UUID()

    var greetingStyle: GreetingStyle = .basic

    var activities: [String]

    // MARK: 수정필요

    var specialNotes: String

    var mealInfo: MealInfo

    var event: PlannedEvent?

    var closingGreetingStyle: ClosingGreetingStyle = .basic
}

let todayReport = SimpleDailyReport(
    greetingStyle: .weather,
    activities: ["숲 속 체험 놀이"],
    specialNotes: "각 원아별 특이 사항이 기록될 예정이에요",
    mealInfo: MealInfo(
        lunchMenu: ["밥", "소세지볶음", "동그랑땡", "마라상궈", "꿔바로우", "나박김치"],
        snackMenu: ["젤리뽀", "벽돌초콜릿", "수건케이크", "다쿠아즈"]
    ),
    event: PlannedEvent(
        title: "점프해서 과자 먹기 대회 예정",
        date: "8.25(월)",
        supplies: []
    ),
    closingGreetingStyle: .mindfulness
)
