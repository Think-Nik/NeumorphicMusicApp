//
//  Image+Extensions.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 26/12/23.
//

import Foundation
import UIKit
import SwiftUI

extension Image {
    
    init?(data: Data?) {
        guard let imageData = data,
              let image = UIImage(data: imageData) else { return nil }
        self = .init(uiImage: image)
    }
}
