//
//  LibraryView.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 19/12/23.
//

import SwiftUI

struct LibraryView: View {
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                LazyVStack(spacing: 20) {
                    SongItemView()
                    SongItemView()
                    SongItemView()
                    SongItemView()
                }
                .padding()
            }
        }
        .background(Color("BackgorundColor"))
    }
    
    struct SongItemView: View {
        var body: some View {
            NeumorphicShape(shape: RoundedRectangle(cornerRadius: 20),
                            backgroundColor: Color("BackgorundColor"),
                            lightShadowColor: Color("LightShadow"),
                            darkShadowColor: Color("DarkShadow"),
                            isPressed: true)
                .overlay {
                    HStack(spacing: 20) {
                        Image(systemName: "music.note.list")
                        VStack(alignment: .leading) {
                            Text("Song Name")
                            Text("Details")
                        }
                        Spacer()
                    }
                    .padding()
                }
                .frame(height: 60)
        }
    }
}

#Preview {
    LibraryView()
}
