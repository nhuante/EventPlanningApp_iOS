//
//  Vendor.swift
//  EventPlanningApp
//
//  Created by Natalie Huante on 5/15/24.
//

import Foundation

struct Vendor : Identifiable, Hashable {
    var id = UUID()
    var name: String
    var category: String
    var amount: Double
    var details: String
}
