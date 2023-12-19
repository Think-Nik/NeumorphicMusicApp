//
//  ContentView.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 18/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab: Int = 0
    @State var title: String = "Now Playing"
    
    var body: some View {
        VStack {
            TopBar(title: $title)
                .padding(.horizontal, 20)
            TabView(selection: $selectedTab) {
                PlayerView()
                    .tag(0)
                
                LibraryView()
                    .tag(1)
                
                PlayerView()
                    .tag(2)
            }
            ZStack {
                HStack {
                    ForEach((TabItems.allCases), id: \.self) { item in
                        Button {
                            selectedTab = item.rawValue
                            title = item.title
                        } label: {
                            CustomTabItem(imageName: item.icon, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
        }
        .background(Color("BackgorundColor"))
    }
    
    struct TopBar: View {
        
        @Binding var title: String
        var body: some View {
            HStack {
                NeumorphicButtonView(isHighlated: .constant(false), image: Image(systemName: "arrow.backward"), padding: 15) {
                    print("back button pressed")
                }
                .frame(width: 30, height: 30)
                Spacer()
                
                Text(title)
                    .fontDesign(.rounded)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("ContentColor"))
                    .font(.system(size: 18))
                Spacer()
                
                NeumorphicButtonView(isHighlated: .constant(false), image: Image(systemName: "line.3.horizontal"), padding: 15) {
                    print("more button pressed")
                }
                .frame(width: 30, height: 30)
            }
//            .padding(30)
            .frame(height: 60)
        }
    }
    
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
            ZStack {
                NeumorphicShape(shape: Capsule(),
                                            backgroundColor: Color("BackgorundColor"),
                                            lightShadowColor: Color("LightShadow"),
                                            darkShadowColor: Color("DarkShadow"),
                                            isHighlighted: isActive)
                VStack(spacing: 5) {
                    Image(systemName: imageName)
                        
                    Text(title)
                        .font(.caption2)
                        .bold()
                }
                .foregroundStyle(isActive ? .white : .black)
            }
            .frame(height: 60)
            .cornerRadius(30)
        }
}

#Preview {
    ContentView()
}
