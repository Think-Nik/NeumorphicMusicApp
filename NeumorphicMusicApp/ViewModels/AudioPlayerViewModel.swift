//
//  AudioPlayerViewModel.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 26/12/23.
//

import Foundation
import Combine

class AudioPlayerViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var songs: [SongDetails] = []
    @Published var isLoading: Bool = true
    @Published var currentSongIndex: Int = 0
    @Published var currentTime: Double = 0.0
    
    private var canellable: AnyCancellable?
    private let songsName: [String] = ["Prologue & subtitle", "Makafushigi Adventure", "Cha-la head-cha-la"]
    
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var timeObservation: Any?

    // MARK: - Init
    init() {
        getSongs()
    }
    
    
    // MARK: - Methods
    private func getSongs() {
        songsName.forEach { name in
            guard let details = AudioManager.shared.getSongDetails(from: name) else {
                return
            }
            songs.append(details)
        }
        isLoading = false
        canellable = AudioManager.shared.publisher.sink { [weak self] time in
            guard let strongSelf = self else {
                return
            }
            if time == 1000.0 {
                print("stooped")
                if strongSelf.songs.indices.contains(strongSelf.currentSongIndex + 1) {
                    strongSelf.currentSongIndex += 1
                    AudioManager.shared.play(fileName: strongSelf.songsName[strongSelf.currentSongIndex] )
                }
                self?.currentTime = 0.0
                self?.publisher.send(0.0)
            } else {
                self?.currentTime = Double(time)
                self?.publisher.send(time)
            }
        }
    }
    
    func play() {
        AudioManager.shared.play(fileName: songsName[currentSongIndex])
    }
    
    func playSong(at index: Int) {
        currentSongIndex = index
        AudioManager.shared.deactivateSession()
        AudioManager.shared.play(fileName: songsName[currentSongIndex])
    }
    
    func pause() {
        AudioManager.shared.pause()
    }
    
    func seek(to time: Double) {
        AudioManager.shared.seek(to: time)
    }
    
    func next() {
        if songs.indices.contains(currentSongIndex + 1) {
            currentSongIndex += 1
        } else {
            currentSongIndex = 0
        }
        AudioManager.shared.deactivateSession()
        AudioManager.shared.play(fileName: songsName[currentSongIndex])
    }
    
    func previous() {
        if songs.indices.contains(currentSongIndex - 1) {
            currentSongIndex -= 1
        } else {
            currentSongIndex = songs.count - 1
        }
        AudioManager.shared.deactivateSession()
        AudioManager.shared.play(fileName: songsName[currentSongIndex])
    }
}
