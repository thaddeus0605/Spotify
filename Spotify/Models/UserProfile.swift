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
    let images: [UserImage]
    let product: String
    let type: String
}

struct UserImage: Codable {
    let url: String
}

//
//
//    id = 01nvb0somm48hpas0u485m7xq;
//    images =     (
//    );
//    product = free;
//    type = user;
//    uri = "spotify:user:01nvb0somm48hpas0u485m7xq";
//}
