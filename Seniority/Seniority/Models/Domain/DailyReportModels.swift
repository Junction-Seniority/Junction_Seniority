//
//  DailyReportModels.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

struct DailyReport {
    let id: UUID
    let date: Date
    let childId: String
    let activities: [Activity]
    let meals: [Meal]
    let healthNotes: [HealthNote]
    let generalNotes: String?
    let teacherName: String
    
    init(date: Date = Date(), childId: String, activities: [Activity] = [], meals: [Meal] = [], healthNotes: [HealthNote] = [], generalNotes: String? = nil, teacherName: String) {
        self.id = UUID()
        self.date = date
        self.childId = childId
        self.activities = activities
        self.meals = meals
        self.healthNotes = healthNotes
        self.generalNotes = generalNotes
        self.teacherName = teacherName
    }
}

struct Activity {
    let id: UUID
    let name: String
    let description: String
    let time: Date
    let participation: ParticipationLevel
    
    init(name: String, description: String, time: Date = Date(), participation: ParticipationLevel) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.time = time
        self.participation = participation
    }
}

enum ParticipationLevel: String, CaseIterable {
    case excellent
    case good
    case moderate
    case needsHelp = "needs_help"
    
    var displayName: String {
        switch self {
        case .excellent:
            return "매우 좋음"
        case .good:
            return "좋음"
        case .moderate:
            return "보통"
        case .needsHelp:
            return "도움 필요"
        }
    }
    
    var emoji: String {
        switch self {
        case .excellent:
            return "😊"
        case .good:
            return "🙂"
        case .moderate:
            return "😐"
        case .needsHelp:
            return "😟"
        }
    }
}

struct Meal {
    let id: UUID
    let type: MealType
    let items: [String]
    let amount: ConsumptionLevel
    let notes: String?
    
    init(type: MealType, items: [String], amount: ConsumptionLevel, notes: String? = nil) {
        self.id = UUID()
        self.type = type
        self.items = items
        self.amount = amount
        self.notes = notes
    }
}

enum MealType: String, CaseIterable {
    case breakfast
    case lunch
    case snack
    case dinner
    
    var displayName: String {
        switch self {
        case .breakfast:
            return "아침"
        case .lunch:
            return "점심"
        case .snack:
            return "간식"
        case .dinner:
            return "저녁"
        }
    }
    
    var icon: String {
        switch self {
        case .breakfast:
            return "🌅"
        case .lunch:
            return "🍱"
        case .snack:
            return "🍪"
        case .dinner:
            return "🌙"
        }
    }
}

enum ConsumptionLevel: String, CaseIterable {
    case all
    case most
    case half
    case little
    case none
    
    var displayName: String {
        switch self {
        case .all:
            return "완식"
        case .most:
            return "많이 먹음"
        case .half:
            return "절반"
        case .little:
            return "조금"
        case .none:
            return "안 먹음"
        }
    }
    
    var emoji: String {
        switch self {
        case .all:
            return "😋"
        case .most:
            return "🙂"
        case .half:
            return "😐"
        case .little:
            return "😕"
        case .none:
            return "😟"
        }
    }
}

struct HealthNote {
    let id: UUID
    let type: HealthType
    let description: String
    let time: Date?
    let severity: Severity
    
    init(type: HealthType, description: String, time: Date? = nil, severity: Severity) {
        self.id = UUID()
        self.type = type
        self.description = description
        self.time = time
        self.severity = severity
    }
}

enum HealthType: String, CaseIterable {
    case temperature
    case medication
    case injury
    case mood
    case sleep
    case toilet
    
    var displayName: String {
        switch self {
        case .temperature:
            return "체온"
        case .medication:
            return "투약"
        case .injury:
            return "부상"
        case .mood:
            return "기분"
        case .sleep:
            return "수면"
        case .toilet:
            return "배변"
        }
    }
    
    var icon: String {
        switch self {
        case .temperature:
            return "🌡️"
        case .medication:
            return "💊"
        case .injury:
            return "🩹"
        case .mood:
            return "😊"
        case .sleep:
            return "😴"
        case .toilet:
            return "🚽"
        }
    }
}

enum Severity: String, CaseIterable {
    case normal
    case attention
    case concern
    
    var displayName: String {
        switch self {
        case .normal:
            return "정상"
        case .attention:
            return "관심"
        case .concern:
            return "주의"
        }
    }
    
    var color: String {
        switch self {
        case .normal:
            return "green"
        case .attention:
            return "yellow"
        case .concern:
            return "red"
        }
    }
}
