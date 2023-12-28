//
//  SongDetails.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 26/12/23.
//

import Foundation

struct SongDetails: Identifiable {
    var id = UUID()
    var name: String
    var album: String
    var artist: String
    var duration: Double
    var albumArt: Data?
}
