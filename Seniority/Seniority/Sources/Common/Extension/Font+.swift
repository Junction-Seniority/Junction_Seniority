//
//  Font+.swift
//  Seniority
//
//  Created by 이현주 on 8/23/25.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretend {
        case bold
        case regular
        case light
        
        var value: String {
            switch self {
            case .bold:
                return "Pretendard-Bold"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretendBold24() -> Font {
        return .custom(Pretend.bold.value, size: 24)
    }
    
    static func pretendRegular24() -> Font {
        return .custom(Pretend.regular.value, size: 24)
    }
    
    static func pretendBold20() -> Font {
        return .custom(Pretend.bold.value, size: 20)
    }
    
    static func pretendBold16() -> Font {
        return .custom(Pretend.bold.value, size: 16)
    }
    
    static func pretendRegular16() -> Font {
        return .custom(Pretend.regular.value, size: 16)
    }
    
    static func pretendLight14() -> Font {
        return .custom(Pretend.light.value, size: 14)
    }
    
    static func pretendLight12() -> Font {
        return .custom(Pretend.light.value, size: 12)
    }
}
