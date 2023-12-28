//
//  String+Extensions.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 27/12/23.
//

import Foundation

extension String {
    func toDouble() -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.doubleValue ?? 0.0
    }
}
