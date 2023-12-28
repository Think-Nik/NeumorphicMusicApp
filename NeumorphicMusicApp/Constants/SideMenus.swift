//
//  SideMenus.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 20/12/23.
//

import Foundation


enum SideMenus: Int, CaseIterable {
    
    case home = 0
    case favorite
    case saved
    case profile
    
    
    var title: String {
        
        switch self {
        case .home:
            return "Home"
        case . favorite:
            return "Favorite"
        case .saved:
            return "Saved"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: String {
        
        switch self {
        case .home:
            return "music.note.house"
        case .favorite:
            return "heart.text.square"
        case .saved:
            return "bookmark.circle"
        case .profile:
            return "person.crop.circle"
        }
    }
}
