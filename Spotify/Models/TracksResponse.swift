//
//  TracksResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/18/23.
//

import Foundation

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
