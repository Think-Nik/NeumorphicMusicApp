//
//  PlayerView.swift
//  NeumorphicMusicApp
//
//  Created by Macbook-pro on 07/07/23.
//

import SwiftUI


struct PlayerView: View {
    
    @State var isPlaying: Bool = true
    @State var maxValue: Double = 30
    @State var currentValue: Double = 0
    @State var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TopBar()
                NeumorphicShape(shape: Circle(),
                                backgroundColor: Color("BackgorundColor"),
                                lightShadowColor: Color("LightShadow"),
                                darkShadowColor: Color("DarkShadow"),
                                isPressed: false)
                .overlay(content: {
                    AlbumArt(isPlaying: $isPlaying)
                })
                .frame(width: geometry.size.width * 0.7)
                .padding(.top, 40)
                
                SongDetails()
                CustomSlider(value: $currentValue, maxValue: maxValue)
                    .frame(height: 15)
                    .padding()
                ButtonView(isPlaying: $isPlaying)
            }
            .padding(.top, 40)
        }
        .onAppear(perform: {
            startTimer()
        })
        .edgesIgnoringSafeArea(.all)
        .background(Color("BackgorundColor"))
    }
    
    
    struct TopBar: View {
        var body: some View {
            HStack {
                NeumorphicButton(isHighlated: .constant(false), image: Image(systemName: "arrow.backward"), padding: 15) {
                    print("back button pressed")
                }
                .frame(width: 30, height: 30)
                Spacer()
                
                Text("PLAYING NOW")
                    .fontDesign(.rounded)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("ContentColor"))
                    .font(.system(size: 14))
                Spacer()
                
                NeumorphicButton(isHighlated: .constant(false), image: Image(systemName: "line.3.horizontal"), padding: 15) {
                    print("more button pressed")
                }
                .frame(width: 30, height: 30)
            }
            .padding(30)
            .frame(height: 100)
        }
    }
    
    struct SongDetails: View {
        var body: some View {
            VStack(spacing: 10) {
                Text("Pain")
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundColor(Color("ContentColor"))
                    .font(.system(size: 30))
                Text("Ryan Jones")
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundColor(Color("ContentColor"))
                    .font(.system(size: 14))
            }
            .padding(.top, 40)
        }
    }
    
    struct ButtonView: View {
        
        @Binding var isPlaying: Bool
        
        var body: some View {
            HStack(spacing: 50) {
                NeumorphicButton(isHighlated: .constant(false), image: Image(systemName: "backward.fill"), padding: 30) {
                    print("previous button pressed")
                }
                .frame(width: 50, height: 50)
        
                NeumorphicButton(isHighlated: $isPlaying, isHighlatedButton: true, image: isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "arrowtriangle.right.fill"), padding: 30) {
                    print("play button pressed")
                    isPlaying.toggle()
                    print("play button toggles", isPlaying)
                }
                .frame(width: 50, height: 50)
                
                NeumorphicButton(isHighlated: .constant(false), image: Image(systemName: "forward.fill"), padding: 30) {
                    print("next button pressed")
                }
                .frame(width: 50, height: 50)
            }
            .padding(.top, 40)
            Spacer()
        }
    }
    
    struct CustomSlider: View {
        @Binding var value: Double
        var maxValue: Double
        
        var body: some View {
            GeometryReader { proxy in
                ZStack(alignment: .center) {
                    NeumorphicShape(shape: RoundedRectangle(cornerRadius: 15), isPressed: true)
                    
                    Capsule()
                        .fill(LinearGradient(colors: [.cyan, .black.opacity(0.8)], startPoint: .bottomTrailing, endPoint: .topLeading))
                        .frame(width: proxy.size.width * (CGFloat(value) / CGFloat(maxValue)))
                        .contentShape(Capsule())
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .overlay(.white, in: Capsule().stroke(style: .init()))
                    
                }
            }
        }
    }
    
    
    struct NeumorphicButton: View {
        
        @Binding var isHighlated: Bool
        var isHighlatedButton: Bool = false
        var image: Image
        var padding: CGFloat
        var backgroundColor: Color = Color("BackgorundColor")
        var lightShadowColor: Color = Color("LightShadow")
        var darkShadowColor: Color = Color("DarkShadow")
        var action: () -> Void
        
        var body: some View {
            GeometryReader { geometry in
                Button {
                    action()
                    if isHighlatedButton {
                        isHighlated.toggle()
                    }
                } label: {
                    image
                        .resizable()
                        .frame(width: geometry.size.width / 3, height: geometry.size.height / 3)
                }
                .addNeumorphicEffect(shape: Circle(),
                                     backgroundColor: backgroundColor,
                                     lightShadowColor: lightShadowColor,
                                     darkShadowColor: darkShadowColor,
                                     isHighlighted: isHighlated,
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
    
    struct AlbumArt: View {
        
        @State private var isRotating = true
        @State private var rotationAngle = 0.0
        @State private var timerForRotation: Timer?
        @Binding var isPlaying: Bool
        
        var body: some View {
            ZStack {
                Image("artistic-album-cover-design-template-d12ef0296af80b58363dc0deef077ecc_screen")
                    .resizable()
                    .clipShape(Circle())
                    .padding(10)
                Circle()
                    .foregroundColor(Color("LightShadow"))
                    .frame(width: 70)
                Circle()
                    .foregroundColor(Color("BackgorundColor"))
                    .frame(width: 25)
            }
            .rotationEffect(Angle(degrees: Double(rotationAngle)))
            .animation(Animation.easeOut(duration: 0.1), value: isRotating)
            .onAppear {
                startTimer()
            }
        }
        
        func startTimer() {
            if timerForRotation == nil {
                timerForRotation = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    if !isPlaying {
                        timerForRotation?.invalidate()
                    }
                    rotationAngle += 0.5
                    print("rotationAngle", rotationAngle)
                    if rotationAngle == 360 {
                        rotationAngle = 0.0
                    }
                }
            }
        }
        
        func stopTimer() {
            timerForRotation?.invalidate()
            timerForRotation = nil
            rotationAngle = 0
        }
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                print("currentValue---", currentValue)
                print("maxValue---", maxValue)
                if currentValue >= maxValue {
                    currentValue = 0
                    timer?.invalidate()
                    isPlaying.toggle()
                } else {
                    currentValue += 1.0
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

