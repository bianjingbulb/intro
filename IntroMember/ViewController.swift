//
//  ViewController.swift
//  IntroMember
//
//  Created by BIAN JING on 9/5/16.
//  Copyright © 2016 CA. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ResetCorrectKeyCodeDelegate {

    var targetVideoName: String!
    var correctKey: UInt16!
    var inputtedKey: UInt16!
    var isPlaying = false

    var videoViewController = VideoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // keyboard通知
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDownMask) { (aEvent) -> NSEvent? in
            self.keyDown(aEvent)
            return aEvent
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        }
    }

    // Keyboardイベント
    override func keyDown(theEvent: NSEvent) {

        if self.correctKey == nil && self.inputtedKey == nil {
            self.correctKey = theEvent.keyCode
            print("正解セット完了！--- \(self.correctKey)")
        } else {
            self.inputtedKey = theEvent.keyCode
            if self.correctKey == self.inputtedKey && self.isPlaying == false {
                switch self.correctKey {
                case 1:
                    self.playVideo("sample1")
                case 2:
                    self.playVideo("sample2")
                default:
                    self.correctKey = nil
                    self.inputtedKey = nil
                    print("番号：\(self.correctKey) ビデオがありません！正解をリセットしてください")
                }
            } else {
                print("無効key！--- \(theEvent.keyCode)")
            }
        }
    }

    // ビデオを流す
    func playVideo(name: String) {
        self.isPlaying = true
        self.targetVideoName = name
        self.performSegueWithIdentifier("showVideoView", sender: self)
        print("番号：\(self.correctKey) ビデオを流しています！")
    }

    // Segueの設定関数
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideoView" {
            let vc = segue.destinationController as! VideoViewController
            vc.videoName = self.targetVideoName
            // delegatgeをセットする
            self.videoViewController = vc
            self.videoViewController.resetDelegate = self
        }
    }

    // MARK:- ResetCorrectKeyCodeDelegate
    func afterVideoDidFinished() {
        print("ビデオ流し完了！--- 正解をリセットしてください")
        self.correctKey = nil
        self.inputtedKey = nil
        self.isPlaying = false
    }
}

