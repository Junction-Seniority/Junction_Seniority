//
//  DummyChild.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//
import SwiftUI

struct ChildDummy: Identifiable {
    let id = UUID()
    var name: String
    var birth: Date
    var schedules: [String]
    var notes: [String]
}

class DummyChild {
    static var children: [ChildDummy] = [
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
}
