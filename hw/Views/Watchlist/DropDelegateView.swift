//
//  DropDelegateView.swift
//  hw
//
//  Created by Josh Liu on 4/27/21.
//

import SwiftUI

struct DropDelegateView: DropDelegate {
    var display: DisplayData
    var watchlistData: WatchlistModel
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    func dropEntered(info: DropInfo) {
        let fromIndex = watchlistData.watchlist.firstIndex{
            (display) -> Bool in
            return display.id == watchlistData.currentDisplay?.id
        } ?? 0
        
        let toIndex = watchlistData.watchlist.firstIndex{
            (display) -> Bool in
            return display.id == self.display.id
        } ?? 0
        
        if fromIndex != toIndex {
            debugPrint(fromIndex, toIndex, "saved")
            withAnimation(.default) {
                let fromDisplay = watchlistData.watchlist[fromIndex]
                watchlistData.watchlist[fromIndex] = watchlistData.watchlist[toIndex]
                watchlistData.watchlist[toIndex] = fromDisplay
            }
            watchlistData.saveToLocal()
            
        }
    }
}

