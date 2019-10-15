//
//  ViewController.swift
//  MPRemoteCommandSample
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class ViewController: UIViewController {
    var audioPlayer:AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        // RemoteCommandのセレクタを指定
        addRemoteCommandEvent()
        // 音声ファイルの指定 & 再生
        setupPlayer()
    }

    // RemoteCommandのセレクタを指定
    func addRemoteCommandEvent() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(type(of: self).remoteTogglePlayPause(_:)))
        commandCenter.playCommand.addTarget(self, action: #selector(type(of: self).remotePlay(_:)))
        commandCenter.pauseCommand.addTarget(self, action: #selector(type(of: self).remotePause(_:)))
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(type(of: self).remoteNextTrack(_:)))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(type(of: self).remotePrevTrack(_:)))

    }

    // 音声ファイルの指定 & 再生
    func setupPlayer() {
        let fileName: String? = "sound"
        let fileExtension:String? = "mp3"
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                audioPlayer = nil
            }
        } else {
            fatalError("Url is nil.")
        }
    }

    @objc func remoteTogglePlayPause(_ event: MPRemoteCommandEvent) {
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            } else {
                player.play()
            }
        }
    }

    @objc func remotePlay(_ event: MPRemoteCommandEvent) {
        if let player = audioPlayer {
            player.play()
        }
    }

    @objc func remotePause(_ event: MPRemoteCommandEvent) {
        if let player = audioPlayer {
            player.pause()
        }
    }

    @objc func remoteNextTrack(_ event: MPRemoteCommandEvent) {
    }

    @objc func remotePrevTrack(_ event: MPRemoteCommandEvent) {
    }
}

