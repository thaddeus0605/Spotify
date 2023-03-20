//
//  Artist.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/5/23.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
