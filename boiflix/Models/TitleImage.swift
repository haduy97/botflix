//
//  TitleImage.swift
//  boiflix
//
//  Created by Duy Ha on 20/12/2023.
//

import Foundation

struct TitleImagesResponse: Codable {
    let results: [TitleImage]
}

struct TitleImage: Codable {
    let id: Int
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
}
