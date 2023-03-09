//
//  AuthResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/7/23.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}


