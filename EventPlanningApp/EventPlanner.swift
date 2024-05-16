//
//  EventPlanner.swift
//  EventPlanningApp
//
//  Created by Natalie Huante on 5/15/24.
//

import SwiftUI
import Combine

class EventPlanner: ObservableObject {
    @Published var todoItems: [TodoItem]
    @Published var notes: [Note]
    @Published var vendors: [Vendor]
    @Published var budget: Budget
    
    init(todoItems: [TodoItem] = [], notes: [Note] = [], vendors: [Vendor] = [], budget: Budget = Budget(totalBudget: 0.0, currentSpend: 0.0)) {
        self.todoItems = todoItems
        self.notes = notes
        self.vendors = vendors
        self.budget = budget
    }
}

