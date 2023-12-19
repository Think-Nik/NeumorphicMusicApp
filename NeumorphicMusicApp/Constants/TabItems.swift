//
//  TabItems.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 19/12/23.
//

import Foundation

enum TabItems: Int, CaseIterable {
    
    case nowPlaying = 0
    case library
    case playlist
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
            
        case .library:
            return "Library"
            
        case .playlist:
            return "Playlists"
        }
    }
    
    var icon: String {
        switch self {
        case .nowPlaying:
            return "play.square.stack"

        case .library:
            return "building.columns.fill"
            
        case .playlist:
            return "music.note.list"
        }
    }
}
