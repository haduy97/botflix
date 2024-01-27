//
//  Popular.swift
//  boiflix
//
//  Created by Duy Ha on 20/12/2023.
//

import Foundation

struct PopularsResponse: Codable {
    let results: [Popular]
}

struct Popular: Codable {
    let id: Int
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
    let video: Bool
}
