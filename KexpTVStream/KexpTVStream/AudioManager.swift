//
//  AudioManager.swift
//  KexpTVStream
//
//  Created by Dustin Bergman on 12/20/15.
//  Copyright © 2015 Dustin Bergman. All rights reserved.
//

import UIKit
import AVFoundation

private let kexpStreamUrl = "http://live-aacplus-64.kexp.org/kexp64.aac"

typealias TrackChangeBlock = (nowplaying: NowPlaying) -> Void

class AudioManager: NSObject {
    static let sharedInstance = AudioManager()
    
    //http://www.kexp.org/s/s.aspx?x=3
    //http://www.kexp.org/s/s.aspx?x=5
    
    var audioPlayerItem: AVPlayerItem?
    var audioPlayer: AVPlayer?
    var currentTrackUpdate: TrackChangeBlock?
    
    override init() {
        super.init()
    }
    
    private func initStream() {
        if let streamURL = NSURL.init(string: kexpStreamUrl) {
            audioPlayerItem = AVPlayerItem(URL: streamURL)
            audioPlayerItem?.addObserver(self, forKeyPath: "status", options: [], context: nil)
            audioPlayerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .New, context: nil)
            audioPlayerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .New, context: nil)
            audioPlayerItem?.addObserver(self, forKeyPath: "timedMetadata", options: .New, context: nil)

            audioPlayer = AVPlayer(playerItem: audioPlayerItem!)
        }
    }
    
    private func deInitStream() {
        audioPlayerItem?.removeObserver(self, forKeyPath: "status")
        audioPlayerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        audioPlayerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        audioPlayerItem?.removeObserver(self, forKeyPath: "timedMetadata")
        
        audioPlayer = nil;
        audioPlayerItem = nil;
    }
    
    func play() {
        initStream()
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
        deInitStream()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let playerItem = object as? AVPlayerItem {
            if (keyPath == "status") {
                if (playerItem.status == .ReadyToPlay) {
                    print("Status: Ready to Play")
                }
                else if (playerItem.status == .Failed) {
                    print("Status: Failed to Play")
                    deInitStream()
                }
                else if (playerItem.status == .Unknown) {
                    print("Status: Unknown")
                }
            }
            else if (keyPath == "playbackBufferEmpty") {
                print("playbackBufferEmpty: playbackBufferEmpty")
                pause()
                deInitStream()
            }
            else if (keyPath == "timedMetadata") {
                print("timedMetadata: timedMetadata")
                NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "getNowPlayingInfo", userInfo: nil, repeats: true)


            }
        }
    }
    
    func getNowPlayingInfo() {
        print("printed..")
        KexpController.getNowPlayingInfo({ [unowned self] (nowplaying) -> Void in
            self.currentTrackUpdate?(nowplaying: nowplaying)
        })
    }
}
