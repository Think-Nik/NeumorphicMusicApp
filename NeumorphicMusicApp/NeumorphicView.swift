//
//  NeumorphicView.swift
//  NeumorphicMusicApp
//
//  Created by Macbook-pro on 10/07/23.
//

import Foundation
import SwiftUI

extension View {
    
    public func addNeumorphicEffect<S: Shape>(shape: S, backgroundColor: Color, lightShadowColor: Color, darkShadowColor: Color, isHighlighted: Bool, padding: CGFloat) -> some View {
        buttonStyle(NeumorphicButtonStyle(shape: shape,
                                          backgroundColor: backgroundColor,
                                          lightShadowColor: lightShadowColor,
                                          darkShadowColor: darkShadowColor,
                                          isHighlighted: isHighlighted,
                                          padding: padding))
    }
}
