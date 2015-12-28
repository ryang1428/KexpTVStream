//
//  KexpNowPlayingVC.swift
//  KexpTVStream
//
//  Created by Dustin Bergman on 12/27/15.
//  Copyright © 2015 Dustin Bergman. All rights reserved.
//

import UIKit
import AlamofireImage

class KexpNowPlayingVC: UIViewController, KexpAudioManagerDelegate {

    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var kexpLogo: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var albumNameLabel: UILabel!
    @IBOutlet var albumArtworkView: UIImageView!
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStyleToView()
        
        KexpAudioManager.sharedInstance.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "playPauseButtonAction:")
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)];
        self.view.addGestureRecognizer(tapRecognizer)
    }

    private func updateAlbumArtWork(albumArtUrl: String) {
        if let albumArt =  NSURL(string: albumArtUrl) {
            albumArtworkView.af_setImageWithURL(
                albumArt,
                placeholderImage: nil
            )
        }
    }
    
    func getNowPlayingInfo() {
        KexpController.getNowPlayingInfo({ [unowned self] (nowPlaying) -> Void in
            self.artistNameLabel.text = nowPlaying.artist
            self.trackNameLabel.text = nowPlaying.songTitle
            self.albumNameLabel.text = nowPlaying.album

            if let albumArtUrl =  nowPlaying.albumArtWork {
                self.updateAlbumArtWork(albumArtUrl)
            }
        })
    }
    
    // MARK: - KexpAudioManagerDelegate Methods
    func KexpAudioPlayerDidStartPlaying() {
        getNowPlayingInfo()
        if (timer == nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "getNowPlayingInfo", userInfo: nil, repeats: true)
        }
    }
    
    func KexpAudioPlayerDidStopPlaying() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - @IBAction
    @IBAction func playKexpAction(sender: AnyObject) {
        if (playPauseButton.selected) {
            playPauseButton.setImage(UIImage(named: "playButton"), forState: .Normal)
            KexpAudioManager.sharedInstance.pause()
        }
        else {
            playPauseButton.setImage(UIImage(named: "pauseButton"), forState: .Normal)
            KexpAudioManager.sharedInstance.play()
        }
        
        playPauseButton.selected = !playPauseButton.selected
    }
    
    // MARK: - VC Styling
    private func addStyleToView() {
        let backgroundLayer = KexpStyle.kexpBackgroundGradient()
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
        
        kexpLogo.layer.cornerRadius = 30.0
        kexpLogo.clipsToBounds = true
        
        albumArtworkView.layer.cornerRadius = 30.0
        albumArtworkView.clipsToBounds = true
    }
}
