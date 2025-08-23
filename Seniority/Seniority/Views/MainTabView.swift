//
//  MainTabView.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Image(systemName: "message.circle")
                    Text("채팅")
                }
                .tag(0)

            DailyReportView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("알림장")
                }
                .tag(1)
            TestPage()
                .tabItem {
                    Image(systemName: "flask")
                    Text("알림테스트")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
