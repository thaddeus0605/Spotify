//
//  SearchResult.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/23/23.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
