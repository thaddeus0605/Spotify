//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/11/23.
//

import Foundation

struct FeaturePlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
