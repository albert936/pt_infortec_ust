//
//  Characters.swift
//  Marvel
//
//  Created by Albert on 15/11/20.
//

import Foundation

struct CharactersRoot: Codable {
    let data: CharacterData
}

struct CharacterData: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
