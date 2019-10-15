//
//  ViewController.swift
//  MPRemoteCommandSample
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import ADG

class ViewController: UIViewController {
    private var audioPlayer:AVAudioPlayer?
    private var adg: ADGManagerViewController?
    @IBOutlet weak var adView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        // RemoteCommandのセレクタを指定
        addRemoteCommandEvent()
        // 音声ファイルの指定 & 再生
        setupPlayer()
        // ADGの設定
        setUpADG()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        // インスタンスの破棄
        adg = nil
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

    // ADG初期設定
    func setUpADG() {
        adg = ADGManagerViewController(locationID: "広告枠IDを入れる",
                                       adType: .adType_Free,
                                       rootViewController: self)

        // HTMLテンプレートを使用したネイティブ広告を表示するためには以下のように配置するViewを指定します
        adg?.adSize = CGSize(width: 300, height: 250)
        adg?.addAdContainerView(self.adView)

        adg?.delegate = self

        // ネイティブ広告パーツ取得を有効
        adg?.usePartsResponse = true

        // インフォメーションアイコンのデフォルト表示
        // デフォルト表示しない場合は必ずADGInformationIconViewの設置を実装してください
        adg?.informationIconViewDefault = false
        adg?.setEnableTestMode(true)
        adg?.setEnableSound(true)
        adg?.loadRequest()
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

extension ViewController: ADGManagerViewControllerDelegate {

    func adgManagerViewControllerReceiveAd(_ adgManagerViewController: ADGManagerViewController) {
        print("Received an ad.")
    }

    func adgManagerViewControllerFailed(toReceiveAd adgManagerViewController: ADGManagerViewController, code: kADGErrorCode) {
        print("Failed to receive an ad.")
        // エラー時のリトライは特段の理由がない限り必ず記述するようにしてください。
        switch code {
        case .adgErrorCodeNeedConnection, // ネットワーク不通
        .adgErrorCodeExceedLimit, // エラー多発
        .adgErrorCodeNoAd: // 広告レスポンスなし
            break
        default:
            adgManagerViewController.loadRequest()
        }
    }
}
