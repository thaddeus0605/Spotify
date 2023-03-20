//
//  PlaylistDetailResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/18/23.
//

import Foundation

struct PlaylistDetailResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTrackResponse
}

struct PlaylistTrackResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
