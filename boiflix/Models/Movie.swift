//
//  Movie.swift
//  boiflix
//
//  Created by Duy Ha on 19/12/2023.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
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
