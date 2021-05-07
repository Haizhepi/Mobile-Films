//
//  ytbPlayer.swift
//  hw
//
//  Created by Josh Liu on 4/26/21.
//

import SwiftUI
import youtube_ios_player_helper

// YtbView(videoID: "jQtP1dD6jQ0").frame(height: 200)

struct YtbView : UIViewRepresentable {
    var videoID : String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: videoID, playerVars: ["playsinline": 1])
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        uiView.load(withVideoId: videoID, playerVars: ["playsinline": 1])
    }
}

