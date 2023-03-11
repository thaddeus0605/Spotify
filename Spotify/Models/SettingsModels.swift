//
//  SettingsModels.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/9/23.
//

import Foundation


struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
