//
//  LibraryAlbumsReponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 4/4/23.
//

import Foundation

struct LibraryAlbumResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
