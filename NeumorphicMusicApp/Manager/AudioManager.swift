//
//  AudioManager.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 26/12/23.
//

import Foundation
import AVFoundation
import Combine
import UIKit

final class AudioManager {
    
    static let shared = AudioManager()
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    
    private var canellable: AnyCancellable?
    private var isPlaying: Bool = false
    
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var timeObservation: Any?
    
    private init() {}
    
    deinit {
        canellable?.cancel()
    }
    
    
    private func activateSession() {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ {}
        
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {}
        
        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {}
    }
    
    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            isPlaying = false
        } catch let error as NSError {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    func getSongDetails(from name: String) -> SongDetails? {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "mp3") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: filePath)
        let asset = AVAsset(url: url)
        let metadata = asset.commonMetadata
        
        let duration: CMTime = asset.duration
        let seconds: Float64 = CMTimeGetSeconds(duration)
        
        var songDetails: SongDetails = SongDetails(name: "",
                                                   album: "",
                                                   artist: "",
                                                   duration: seconds,
                                                   albumArt: nil)
        
        for item in metadata {
            if let value = item.value {
                switch item.commonKey?.rawValue {
                case "title":
                    print("Title: \(value)")
                    songDetails.name = value.description
                case "artist":
                    print("Artist: \(value)")
                    songDetails.artist = value.description
                case "albumName":
                    songDetails.album = value.description
                case "artwork":
                    if let imageData = value as? Data {
                        songDetails.albumArt = imageData
                    }
                default:
                    break
                }
            }
        }
        return songDetails
    }
    
    private func startAudio(fileName: String) {
        
        // activate our session before playing audio
        activateSession()
        
        // TODO: change the url to whatever audio you want to play
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "mp3") else {
            return
        }
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: URL(fileURLWithPath: filePath))
        
        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        canellable = NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
            .sink { [weak self] _ in
                guard let me = self else { return }
                self?.isPlaying = false
                me.deactivateSession()
                self?.publisher.send(1000.0)
            }
    }
    
    func play(fileName: String) {
        if isPlaying {
            if let player = player {
                player.play()
            }
        } else {
            startAudio(fileName: fileName)
            if let player = player {
                player.play()
                isPlaying = true
            }
            getCurrentTime()
        }
    }
    
    private func getCurrentTime() {
        timeObservation = player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time: Float64 = CMTimeGetSeconds(self.player!.currentTime())
                self.publisher.send(time)
            }
        }
    }
    
    func pause() {
        if let player = player {
            player.pause()
        }
    }
    
    func seek(to time: Double) {
        let selectedTime: CMTime = CMTimeMake(value: Int64(time * 1000 as Float64), timescale: 1000)
        player?.seek(to: selectedTime)
    }
}
