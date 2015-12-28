//
//  KexpNowPlayingVC.swift
//  KexpTVStream
//
//  Created by Dustin Bergman on 12/27/15.
//  Copyright © 2015 Dustin Bergman. All rights reserved.
//

import UIKit

class KexpNowPlayingVC: UIViewController {

    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var kexpLogo: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var albumNameLabel: UILabel!
    @IBOutlet var albumArtworkView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStyleToView()

        AudioManager.sharedInstance.currentTrackUpdate = { [unowned self] (NowPlaying nowPlaying) in
            self.artistNameLabel.text = nowPlaying.artist
            self.trackNameLabel.text = nowPlaying.songTitle
            self.albumNameLabel.text = nowPlaying.album
            
         //   self.loadImage(NSURL(string: nowPlaying.albumArtWork!)!)
        }
        

    }
    
    private func addStyleToView() {
        let backgroundLayer = KexpStyle.kexpBackgroundGradient()
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
        
        kexpLogo.layer.cornerRadius = 30.0
        kexpLogo.clipsToBounds = true
    }

    @IBAction func playKexpAction(sender: AnyObject) {
        if (playPauseButton.selected) {
            playPauseButton.setImage(UIImage(named: "playButton"), forState: .Normal)
            AudioManager.sharedInstance.pause()
        }
        else {
            playPauseButton.setImage(UIImage(named: "pauseButton"), forState: .Normal)
            AudioManager.sharedInstance.play()
        }
        
        playPauseButton.selected = !playPauseButton.selected
    }
    
}
