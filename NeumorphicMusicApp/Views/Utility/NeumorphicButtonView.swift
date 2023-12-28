//
//  NeumorphicButton.swift
//  NeumorphicMusicApp
//
//  Created by Macbook-pro on 10/07/23.
//

import Foundation
import SwiftUI


extension Button {
    
    public func addNeumorphicEffect<S: Shape>(shape: S, backgroundColor: Color, lightShadowColor: Color, darkShadowColor: Color, isHighlighted: Bool, padding: CGFloat) -> some View {
        buttonStyle(NeumorphicButtonStyle(shape: shape,
                                          backgroundColor: backgroundColor,
                                          lightShadowColor: lightShadowColor,
                                          darkShadowColor: darkShadowColor,
                                          isHighlighted: isHighlighted,
                                          padding: padding))
    }
}

struct NeumorphicButtonView<S: Shape, V: View>: View {
    
    var shape: S
    var view: V
    @Binding var isHighlited: Bool
    var isHighlitedButton: Bool = false
    var padding: CGFloat
    var backgroundColor: Color = Color("BackgorundColor")
    var lightShadowColor: Color = Color("LightShadow")
    var darkShadowColor: Color = Color("DarkShadow")
    var action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                action()
                if isHighlitedButton {
                    isHighlited.toggle()
                }
            } label: {
                view
//                image
//                    .resizable()
//                    .frame(width: geometry.size.width / 3, height: geometry.size.height / 3)
            }
            .addNeumorphicEffect(shape: shape,
                                 backgroundColor: backgroundColor,
                                 lightShadowColor: lightShadowColor,
                                 darkShadowColor: darkShadowColor,
                                 isHighlighted: isHighlited,
                                 padding: padding)
            .frame(width: geometry.size.width, height: geometry.size.height)
//                .onLongPressGesture {
//
//                } onPressingChanged: { _ in
//                    action()
//                    isPressed.toggle()
//                }
        }
    }
}


public struct NeumorphicButtonStyle<S: Shape>: ButtonStyle {
    
    var shape: S
    var backgroundColor: Color
    var lightShadowColor: Color
    var darkShadowColor: Color
    var isHighlighted: Bool
    var padding: CGFloat
    
    
    public init(shape: S, backgroundColor: Color, lightShadowColor: Color, darkShadowColor: Color, isHighlighted: Bool, padding: CGFloat) {
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.lightShadowColor = lightShadowColor
        self.darkShadowColor = darkShadowColor
        self.padding = padding
        self.isHighlighted = isHighlighted
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        NeumorphicButton(configuration: configuration,
                         shape: shape,
                         backgroundColor: backgroundColor,
                         lightShadowColor: lightShadowColor,
                         darkShadowColor: darkShadowColor,
                         isHighlighted: isHighlighted,
                         padding: padding)
    }
    
    struct NeumorphicButton: View {
        
        let configuration: ButtonStyle.Configuration
        var shape: S
        var backgroundColor: Color
        var lightShadowColor: Color
        var darkShadowColor: Color
        var isHighlighted: Bool
        var padding: CGFloat
        
        
        var body: some View {
            ZStack {
                configuration.label
                    .padding(padding)
                    .scaleEffect(configuration.isPressed ? 0.90 : 1)
                    .background {
                        NeumorphicShape(shape: shape,
                                        backgroundColor: backgroundColor,
                                        lightShadowColor: lightShadowColor,
                                        darkShadowColor: darkShadowColor,
                                        isPressed: configuration.isPressed,
                                        isHighlighted: isHighlighted)
                    }
            }
        }
    }
}

