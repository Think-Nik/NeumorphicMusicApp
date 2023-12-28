//
//  TimeInterval+Extensions.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 26/12/23.
//

import Foundation

extension TimeInterval {
    
    func stringFromTimeInterval() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        //        let hours = (interval / 3600)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
