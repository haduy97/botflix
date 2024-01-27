//
//  TVShow.swift
//  boiflix
//
//  Created by Duy Ha on 20/12/2023.
//

import Foundation

struct TVShowsResponse: Codable {
    let results: [TVShow]
}

struct TVShow: Codable {
    let id: Int
    let name: String?
    let original_language: String?
    let original_name: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let media_type: String?
    let first_air_date: String?
    let vote_average: Double
    let vote_count: Int
    let origin_country: [String]?
}
