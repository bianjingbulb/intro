//
//  VideoViewController.swift
//  IntroMember
//
//  Created by BIAN JING on 9/5/16.
//  Copyright © 2016 CA. All rights reserved.
//

import Cocoa
import AVKit
import Foundation
import AVFoundation

protocol ResetCorrectKeyCodeDelegate {
    func afterVideoDidFinished() -> Void
}

class VideoViewController: NSViewController {

    @IBOutlet var playerView: AVPlayerView!

    var videoPlayer:AVPlayer!
    var videoName: String!

    var resetDelegate: ResetCorrectKeyCodeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // AVPlayerItemDidPlayToEndTimeNotificationを生成
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoViewController.playerItemDidFinished), name: AVPlayerItemDidPlayToEndTimeNotification, object: videoPlayer?.currentItem)

        let avAsset = getVideoAsset(videoName, type: "mov")

        // AVPlayerに再生させるアイテムを生成.
        let playerItem = AVPlayerItem(asset: avAsset)

        // AVPlayerを生成.
        videoPlayer = AVPlayer(playerItem: playerItem)
        playerView.player = videoPlayer

        videoPlayer.play()
    }

    func getVideoAsset(name: String, type: String) -> AVURLAsset {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: type)
        let fileURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(URL: fileURL, options: nil)
        return avAsset
    }

    // ビデオが終了した後の処理
    func playerItemDidFinished()  {
        self.resetDelegate?.afterVideoDidFinished()
        self.view.window?.windowController?.close()
    }
}
