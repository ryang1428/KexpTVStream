//
//  File.swift
//  KexpTVStream
//
//  Created by Dustin Bergman on 12/23/15.
//  Copyright © 2015 Dustin Bergman. All rights reserved.
//

import UIKit
import Alamofire

class KexpController {

   class func getNowPlayingInfo(currentTrackUpdate: TrackChangeBlock) {
        Alamofire.request(.GET, "http://www.kexp.org/s/s.aspx?x=3", parameters: [:])
            .responseJSON { response in
                if let nowplayingResponse = response.result.value as? [String:AnyObject] {
                    let nowPlaying = NowPlaying(nowPlayingDictionary: nowplayingResponse)
                    currentTrackUpdate(nowplaying: nowPlaying)
                }
        }
    }
}