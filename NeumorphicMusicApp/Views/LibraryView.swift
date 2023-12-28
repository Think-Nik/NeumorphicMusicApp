//
//  LibraryView.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 19/12/23.
//

import SwiftUI

struct LibraryView: View {
    
    @Binding var isShowing: Bool
    @ObservedObject var viewModel: AudioPlayerViewModel
    var edgeTransition: AnyTransition = .move(edge: .bottom)
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack {
                    NeumorphicButtonView(shape: Circle(),
                                         view: Image(systemName: "xmark"),
                                         isHighlited: .constant(false),
                                         padding: 15) {
                        isShowing.toggle()
                    }
                                         .frame(height: 50)
                                         .foregroundColor(Color("ContentColor"))
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundStyle(
                            Color("BackgorundColor")
                        )
                        .overlay {
                            VStack {
                                ScrollView {
                                    ScrollViewReader { scrollView in
                                        LazyVStack {
                                            ForEach(viewModel.songs.indices) { index in
                                                SongItemView(song: $viewModel.songs[index],
                                                             index: String(index + 1))
                                                .background {
                                                    index == viewModel.currentSongIndex ? Color.orange.opacity(0.2) : Color.clear
                                                }
                                                .onTapGesture {
                                                    viewModel.playSong(at: index)
                                                    isShowing.toggle()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .background(LinearGradient(colors: [Color("LightShadow"), Color("DarkShadow")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                        .transition(edgeTransition)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.top, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
    
    struct SongItemView: View {
        
        @State var isPressed: Bool = false
        @State private var isFavorite: Bool = true
        @Binding var song: SongDetails
        
        var index: String
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 0.2)
                        .overlay {
                            Text(index)
                                .font(.caption)
                                .bold()
                                .foregroundColor(Color("ContentColor"))
                        }
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(song.name)
                            .font(.callout)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("ContentColor"))
                        Text(song.duration.stringFromTimeInterval())
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    
                    NeumorphicButtonView(shape: Circle(),
                                         view: Image(systemName: isFavorite ? "heart.fill" : "heart"),
                                         isHighlited: $isFavorite,
                                         padding: 15) {
                        isFavorite.toggle()
                    }
                                         .frame(width: 60, height: 60)
                                         .padding(.trailing)
                                         .foregroundStyle(isFavorite ? Color.orange : Color("ContentColorLight"))
                }
                .padding(.horizontal)
                Rectangle()
                    .frame(height: 0.4)
                    .foregroundStyle(.gray.opacity(0.4))
            }
            .padding(.top)
            .ignoresSafeArea()
        }
    }
}
