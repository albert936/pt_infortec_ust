//
//  Api.swift
//  Marvel
//
//  Created by Albert on 15/11/20.
//

import Foundation

struct Api {
    struct apiKey {
        static let key = "apikey"
        static let publicKey = "e175fb408ad6d3dbd0e760f9bdc729f2"
        static let privateKey = "2f3623362d4e14d3f290d2cc47f24161f3628d3f"
    }
    
    struct url {
        static let base = "https://gateway.marvel.com:443/v1/public/"
        static let characters = "characters"
        static let characterDetail = "characters/%d"
    }
}
