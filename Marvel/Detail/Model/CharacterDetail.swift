//
//  CharacterDetail.swift
//  Marvel
//
//  Created by Albert on 16/11/20.
//

import Foundation

struct CharacterDetailRoot: Codable {
    let data: CharacterDetailData
}

struct CharacterDetailData: Codable {
    let results: [CharacterDetail]
    
}

struct CharacterDetail: Codable {
    let id: Int
    let name: String
    let description: String
    let image: Thumbnail
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case image = "thumbnail"
    }
}

struct Thumbnail: Codable {
    let path: String
    let ext: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}

extension Thumbnail {
    var fullPath: String {
        return "\(path).\(ext)"
    }
}
