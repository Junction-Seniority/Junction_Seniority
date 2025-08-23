//
//  Child.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

struct Child {
    let id: String
    let name: String
    let age: Int
    let traits: [String]
    let cautions: Cautions
}

struct Cautions {
    let allergies: [String]
    let environment: [String]
    let diseases: [String]
}
