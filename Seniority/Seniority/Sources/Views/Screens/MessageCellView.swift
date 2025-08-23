//
//  MessageCellView.swift
//  Seniority
//
//  Created by 이현주 on 8/24/25.
//

import SwiftUI

struct MessageCellView: View {
    let message: ChatMessage
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(message.displayContent)
                .body02_16Regular()
                .padding(.all, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.prime60)
                }
            
            Text(Date().timeKorean)
                .foregroundStyle(Color.black70)
                .body03_14Light()
        }
    }
}
