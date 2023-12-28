//
//  NeumorphicShape.swift
//  NeumorphicChatController
//
//  Created by Macbook-pro on 06/07/23.
//

import SwiftUI

struct NeumorphicShape<S: Shape>: View {
    
    var shape: S
    var backgroundColor: Color = Color("BackgorundColor")
    var lightShadowColor: Color = Color("LightShadow")
    var darkShadowColor: Color = Color("DarkShadow")
    var isPressed: Bool = false
    var isHighlighted: Bool = false

    var body: some View {
        ZStack {
            if isPressed || isHighlighted {
                shape
                    .stroke(LinearGradient(colors: [darkShadowColor.opacity(0.4), lightShadowColor.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomLeading), lineWidth: 2)
                    .overlay(
                            shape
                                .stroke(darkShadowColor, lineWidth: 4)
                                .blur(radius: 3)
                                .offset(x: 2, y: 2)
                                .mask(shape.fill(LinearGradient(colors: [.black, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
                        )
                        .overlay(
                            shape
                                .stroke(lightShadowColor, lineWidth: 2)
                                .blur(radius: 3)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(colors: [.black, .clear], startPoint: .bottomTrailing, endPoint: .topLeading)))
                        )
//            } else if isHighlighted {
//                shape
//                    .fill(LinearGradient(colors: [.clear, .black.opacity(0.1)], startPoint: .bottomTrailing, endPoint: .topLeading))
//                    .overlay(shape.stroke(LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
//                    .shadow(color: darkShadowColor, radius: 10, x: 5, y: 5)
//                    .shadow(color: lightShadowColor, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(backgroundColor)
                    .shadow(color: lightShadowColor, radius: 10, x: -5, y: -5)
                    .shadow(color: darkShadowColor.opacity(0.7), radius: 10, x: 10, y: 10)
                    .overlay(shape.stroke(LinearGradient(colors: [lightShadowColor, darkShadowColor], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
            }
        }
    }
}
