//
//  Date+.swift
//  Seniority
//
//  Created by 이현주 on 8/24/25.
//

import Foundation

extension Date {
    var timeKorean: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm" // 오전/오후 h:mm
        return formatter.string(from: self)
    }
}
