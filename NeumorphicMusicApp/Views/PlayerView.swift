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
                NeumorphicShape(shape: Circle(),
                                backgroundColor: Color("BackgorundColor"),
                                lightShadowColor: Color("LightShadow"),
                                darkShadowColor: Color("DarkShadow"),
                                isPressed: false)
                .overlay(content: {
                    ZStack {
                        AlbumArt(isPlaying: $isPlaying)
                        CircularSeekBar(progress: currentValue)
                    }
                })
                .frame(width: geometry.size.width * 0.8)
                .padding()
                SongDetails()
                ButtonView(isPlaying: $isPlaying)
            }
            .frame(width: geometry.size.width)
        }
        .onAppear(perform: {
            startTimer()
        })
        .background(Color("BackgorundColor"))
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
                NeumorphicButtonView(isHighlated: .constant(false), image: Image(systemName: "backward.fill"), padding: 30) {
                    print("previous button pressed")
                }
                .frame(width: 50, height: 50)
        
                NeumorphicButtonView(isHighlated: $isPlaying, isHighlatedButton: true, image: isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "arrowtriangle.right.fill"), padding: 30) {
                    print("play button pressed")
                    isPlaying.toggle()
                    print("play button toggles", isPlaying)
                }
                .frame(width: 50, height: 50)
                
                NeumorphicButtonView(isHighlated: .constant(false), image: Image(systemName: "forward.fill"), padding: 30) {
                    print("next button pressed")
                }
                .frame(width: 50, height: 50)
            }
            .padding(.top, 40)
            Spacer()
        }
    }
    
    struct CircularSeekBar: View {
        
        let progress: Double
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(
                        Color.white.opacity(0.5),
                        lineWidth: 5
                    )
                let _ = print("progress---", progress)
                Circle()
                    .trim(from: 0, to: progress / 100)
                    .stroke(
                        LinearGradient(colors: [.cyan, .black.opacity(0.8)], startPoint: .bottomTrailing, endPoint: .topLeading),
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress / 10)
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
//            .onAppear {
//                startTimer()
//            }
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


#Preview {
    PlayerView()
}
