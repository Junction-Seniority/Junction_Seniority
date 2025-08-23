//
//  DummyReportEdit.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

let DummyReportEdit = SimpleDailyReport(
    greetingStyle: .weather,
    activities: [Activity(title: "즐겁고 건강한 여름을 보내요", content: "여름 바다와 풍경에 관심을 가지 자연의 아름다움을 느끼고 자신이  경험한 것에 대해 나누는 시간을 가져요")],
    specialNotes: "각 원아별 특이 사항이 기록될 예정이에요",
    mealInfo: MealInfo(
        lunchMenu: ["밥", "소세지볶음", "동그랑땡", "마라상궈", "꿔바로우", "나박김치"],
        snackMenu: ["젤리뽀", "벽돌초콜릿", "수건케이크", "다쿠아즈"]
    ),
    event: PlannedEvent(
        title: "점프해서 과자 먹기 대회 예정",
        date: "8.25(월)",
        supplies: "단단한 운동화와 땀을 닦을 수 있는 수건"
    ),
    closingGreetingStyle: .mindfulness
)
