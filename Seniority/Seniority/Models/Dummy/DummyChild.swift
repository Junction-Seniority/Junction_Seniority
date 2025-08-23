//
//  DummyChild.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

class DummyChild {
    static let sampleData: [Child] = [
        Child(
            id: "c001",
            name: "김민수",
            age: 4,
            traits: ["활발함", "친구들과 잘 어울림", "창의적"],
            cautions: Cautions(
                allergies: ["우유 알레르기"],
                environment: ["추운 날씨에 감기 잘 걸림"],
                diseases: []
            )
        ),
        Child(
            id: "c002",
            name: "이도윤",
            age: 5,
            traits: ["사교적임", "호기심 많음"],
            cautions: Cautions(
                allergies: ["땅콩 알레르기"],
                environment: ["큰 소음에 예민", "더운 날씨에 쉽게 지침"],
                diseases: ["천식"]
            )
        ),
        Child(
            id: "c003",
            name: "박소영",
            age: 4,
            traits: ["차분함", "예술적 재능", "독립적"],
            cautions: Cautions(
                allergies: ["계란 알레르기", "새우 알레르기"],
                environment: ["먼지에 예민"],
                diseases: ["아토피"]
            )
        ),
        Child(
            id: "c004",
            name: "최준호",
            age: 5,
            traits: ["리더십", "운동신경 좋음", "도전적"],
            cautions: Cautions(
                allergies: [],
                environment: ["높은 곳에 대한 두려움"],
                diseases: []
            )
        ),
        Child(
            id: "c005",
            name: "정하은",
            age: 4,
            traits: ["친절함", "동물 좋아함", "집중력 좋음"],
            cautions: Cautions(
                allergies: ["견과류 알레르기"],
                environment: ["강한 향에 예민"],
                diseases: []
            )
        )
    ]
}
