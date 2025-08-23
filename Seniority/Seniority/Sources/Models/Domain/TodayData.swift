//
//  TodayData.swift
//  Seniority
//
//  Created by 이현주 on 8/23/25.
//

import Foundation

struct TodayData {
    let date: Date
    let dailyEvents: [Event]
    let dailyMenu: [Menu]
    let dailyInput: DailyInput
}

struct Event {
    let title: String
    let category: String
}

struct Menu {
    let type: String
    let items: [String]
}

struct DailyInput {
    let checklist_resolved: [String]
    let checklist_unresolved: [String]
}

