//
//  Text+.swift
//  Seniority
//
//  Created by 이현주 on 8/23/25.
//

import Foundation
import SwiftUI

extension Text {
    func head01_24Bold() -> some View {
        self.font(.pretendBold24())
            .lineSpacing(31 - 24)
            .kerning(-0.24)
    }
    
    func head02_24Regular() -> some View {
        self.font(.pretendRegular24())
            .lineSpacing(31 - 24)
            .kerning(-0.24)
    }
    
    func subHead01_20Bold() -> some View {
        self.font(.pretendBold20())
            .lineSpacing(26 - 20)
            .kerning(-0.6)
    }
    
    
    func body01_16Bold() -> some View {
        self.font(.pretendBold16())
            .lineSpacing(21 - 16)
            .kerning(-0.32)
    }
    
    
    func body02_16Regular() -> some View {
        self.font(.pretendRegular16())
            .lineSpacing(21 - 16)
            .kerning(-0.32)
    }
    
    
    func body03_14Light() -> some View {
        self.font(.pretendLight14())
            .lineSpacing(18 - 14)
            .kerning(-0.28)
    }
    
    
    func caption01_12Light() -> some View {
        self.font(.pretendLight12())
            .lineSpacing(18 - 12)
            .kerning(-0.24)
    }
}
