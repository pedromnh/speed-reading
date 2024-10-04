//
//  Article.swift
//  Skim
//
//  Created by Pedro Henriques on 04/10/2024.
//

import Foundation

struct Article: Codable, Identifiable {
    var id = UUID()
    var title: String
    var body: String
}
