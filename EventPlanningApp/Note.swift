//
//  Note.swift
//  EventPlanningApp
//
//  Created by Natalie Huante on 5/15/24.
//

import Foundation

struct Note: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var content: String
}
