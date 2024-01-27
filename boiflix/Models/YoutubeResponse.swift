//
//  YoutubeResponse.swift
//  boiflix
//
//  Created by Duy Ha on 26/12/2023.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
