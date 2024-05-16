//
//  TodoItem.swift
//  EventPlanningApp
//
//  Created by Natalie Huante on 5/15/24.
//

import Foundation

struct TodoItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var category: String
    var budget: Double
    var notes: String
}
