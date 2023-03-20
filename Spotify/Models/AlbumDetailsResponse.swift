//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/18/23.
//

import Foundation

struct AlbumDetailsResponses: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]?
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}



