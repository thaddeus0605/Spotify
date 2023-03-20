//
//  Profile.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/5/23.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let product: String
    let type: String
}


