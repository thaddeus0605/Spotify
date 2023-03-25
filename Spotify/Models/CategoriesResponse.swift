//
//  CategoriesResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/21/23.
//

import Foundation

struct CatergoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let icons: [APIImage]
    let name: String
    let id: String
}
