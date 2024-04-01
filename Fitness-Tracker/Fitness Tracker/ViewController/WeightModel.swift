//
//  WeightModel.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 3/20/24.
//

import Foundation

struct WeightModel: Identifiable, Codable {
    let id: UUID
    let weight: Double
    let createAt: Date
    
    init(id: UUID = UUID(), weight: Double, createAt: Date) {
        self.id = id
        self.weight = weight
        self.createAt = createAt
    }
}
