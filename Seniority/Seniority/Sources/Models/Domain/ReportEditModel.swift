import Foundation

struct SimpleDailyReport: Identifiable {
    let id = UUID()

    var greetingStyle: GreetingStyle = .basic

    var activities: [Activity]

    // MARK: 수정필요

    var specialNotes: String

    var mealInfo: MealInfo

    var event: PlannedEvent?

    var closingGreetingStyle: ClosingGreetingStyle = .basic
}

struct Activity: Hashable {
    var title: String
    var content: String
}

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

struct PlannedEvent {
    var title: String
    var date: String
    var supplies: String?
}

struct MealInfo {
    var lunchMenu: [String]
    var snackMenu: [String]
}
