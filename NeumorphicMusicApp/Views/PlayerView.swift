//
//  PlayerView.swift
//  NeumorphicMusicApp
//
//  Created by Macbook-pro on 07/07/23.
//

import SwiftUI
import AVFoundation
import Combine

struct PlayerView: View {
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @State var presentPlaylist = false
    
    @StateObject var viewModel: AudioPlayerViewModel = AudioPlayerViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            if viewModel.isLoading {
                ProgressView()
            } else {
                ZStack {
                    VStack(alignment: .leading) {
                        
                        TopBar(presentSideMenu: $presentSideMenu,
                               presentPlaylist: $presentPlaylist)
                        
                        AlbumArt(viewModel: viewModel)
                            .frame(height: geometry.size.height * 0.35)
                            .padding(.horizontal, geometry.size.width * 0.15)
                            .padding(.vertical, 10)
                        
                        SongDetails(viewModel: viewModel)
                        
                        MusicControlView(viewModel: viewModel)
                            .padding(.top, 30)
                        
                    }
                    
                    SideMenu(isShowing: $presentSideMenu,
                             selectedSideMenuTab: $selectedSideMenuTab)
                    
                    LibraryView(isShowing: $presentPlaylist, 
                                viewModel: viewModel)
                }
                .onAppear(perform: {
                    viewModel.play()
                })
            }
        }
        .background(Color("BackgorundColor"))
    }
    
    
    struct TopBar: View {
        
        @Binding var presentSideMenu: Bool
        @Binding var presentPlaylist: Bool
        
        var body: some View {
            HStack {
                
                Spacer()
                
                createButton(image: Image(systemName: "music.note.list"),
                             padding: 15) {
                    presentPlaylist.toggle()
                }
                
                createButton(image: Image(systemName: "ellipsis"),
                             padding: 23) {
                    presentSideMenu.toggle()
                }
                
            }
            .frame(height: 80)
            .padding(.horizontal)
            .foregroundColor(Color("ContentColorLight"))
        }
        
        private func createButton(image: Image,
                                  padding: CGFloat,
                                  action: (@escaping() -> ())) -> some View {
            NeumorphicButtonView(shape: Circle(),
                                 view: image,
                                 isHighlited: .constant(false),
                                 padding: padding) {
                action()
            }
                                 .frame(width: 80)
        }
    }
    
    
    struct AlbumArt: View {
        
        @ObservedObject var viewModel: AudioPlayerViewModel
        
        var body: some View {
            HStack {
                Spacer()
                NeumorphicShape(shape: RoundedRectangle(cornerRadius: 30))
                    .overlay {
                        if let data = viewModel.songs[viewModel.currentSongIndex].albumArt,
                           let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        } else {
                            Image(systemName: "music.quarternote.3").resizable()
                                .padding(50)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                    }
                Spacer()
            }
            .foregroundColor(Color("ContentColorLight"))
        }
    }
    
    struct SongDetails: View {
        
        @State private var isFavorite: Bool = false
        @ObservedObject var viewModel: AudioPlayerViewModel
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.songs[viewModel.currentSongIndex].name)
                        .foregroundColor(Color("ContentColor"))
                        .font(.system(size: 24))
                    Text(viewModel.songs[viewModel.currentSongIndex].album)
                        .foregroundColor(Color("ContentColorLight"))
                        .font(.system(size: 14))
                }
                .fontDesign(.rounded)
                .bold()
                .padding(.leading, 20)
                
                Spacer()
                
                NeumorphicButtonView(shape: Circle(),
                                     view: Image(systemName: isFavorite ? "heart.fill" : "heart"),
                                     isHighlited: $isFavorite,
                                     padding: 15) {
                    isFavorite.toggle()
                }
                                     .frame(width: 80, height: 80)
                                     .padding(.trailing)
                                     .foregroundStyle(isFavorite ? Color.orange : Color("ContentColorLight"))
            }
            .padding(.top, 30)
            .frame(maxHeight: 120)
        }
    }
    
    
    struct MusicControlView: View {
        
        @State var isPlaying: Bool = false
        @State var isShuffled: Bool = false
        @State var isRepeated: Bool = false
        @State private var sliderValue: Double = .zero
        @ObservedObject var viewModel: AudioPlayerViewModel
        @State private var canellable: AnyCancellable?
        
        var body: some View {
            
            NeumorphicShape(shape: RoundedRectangle(cornerRadius: 50),
                            isPressed: true)
            .overlay {
                VStack(spacing: 20) {
                    HStack {
                        createTimer(text: viewModel.currentTime.stringFromTimeInterval())
                        Slider(
                            value: $sliderValue,
                            in: 0...(viewModel.songs[viewModel.currentSongIndex].duration)) { isChanged in
                                print(viewModel.currentTime)
                                viewModel.seek(to: sliderValue)
                            }
                            .tint(.orange)
                        
                        createTimer(text: viewModel.songs[viewModel.currentSongIndex].duration.stringFromTimeInterval())
                    }
                    .padding(5)
                    .padding(.bottom)
                    
                    HStack(alignment: .center, spacing: 30) {
                        createButton(image: Image(systemName: "shuffle"),
                                     isHilighted: $isShuffled) {
                            isShuffled.toggle()
                        }
                        
                        Button(action: {
                            viewModel.previous()
                        }, label: {
                            Image(systemName: "backward.end.fill")
                        })
                        .frame(width: 40, height: 40)
                        
                        createButton(image: isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "arrowtriangle.right.fill"),
                                     isHilighted: $isPlaying,
                                     padding: 30) {
                            isPlaying ? viewModel.pause() : viewModel.play()
                            isPlaying.toggle()
                        }
                        
                        Button(action: {
                            viewModel.next()
                        }, label: {
                            Image(systemName: "forward.end.fill")
                        })
                        .frame(width: 40, height: 40)
                        
                        createButton(image: Image(systemName: "repeat"),
                                     isHilighted: $isRepeated) {
                            isRepeated.toggle()
                        }
                    }
                }
                .foregroundColor(Color("ContentColorLight"))
                .padding(5)
                .onAppear(perform: {
                    canellable = viewModel.publisher.sink(receiveValue: { value in
                        sliderValue = value
                        //                            isPlaying = value != 0.0
                    })
                    isPlaying = true
                })
            }
            .ignoresSafeArea()
        }
        
        private func createTimer(text: String) -> some View {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 0.2)
                .overlay {
                    Text(text)
                        .font(.caption)
                        .bold()
                }
                .frame(width: 50, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
        private func createButton(image: Image,
                                  isHilighted: Binding<Bool>,
                                  padding: CGFloat = 15,
                                  action: (@escaping() ->())) -> some View {
            NeumorphicButtonView(shape: Circle(),
                                 view: image,
                                 isHighlited: isHilighted,
                                 padding: padding) {
                action()
            }
                                 .frame(width: 50, height: 50)
                                 .foregroundStyle(isHilighted.wrappedValue ? Color.orange : Color("ContentColorLight"))
        }
    }
}
