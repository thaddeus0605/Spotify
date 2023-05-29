//
//  LibraryPlaylistResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/31/23.
//

import Foundation


struct LibraryPlaylistResponse: Codable {
    let items: [Playlist]
}
