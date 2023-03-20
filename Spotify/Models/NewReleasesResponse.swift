//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/11/23.
//

import Foundation

struct NewReleaseResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}





