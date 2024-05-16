//
//  Budget.swift
//  EventPlanningApp
//
//  Created by Natalie Huante on 5/15/24.
//

import Foundation

struct Budget : Identifiable, Hashable {
    var id = UUID()
    var totalBudget: Double
    var currentSpend: Double
}
