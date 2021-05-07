//
//  WatchlistModel.swift
//  hw
//
//  Created by Josh Liu on 4/27/21.
//

import SwiftUI

class WatchlistModel: ObservableObject {
    @Published var watchlist: [DisplayData] = []
    
    @Published var currentDisplay: DisplayData?
    
    @Published var showToast = false
    @Published var toastMessage = "This is a toast long long lomng londgs sa dsdfsdfsdafewf a"
    
    func addToList(display: DisplayData) {
        self.watchlist.append(display)
        self.saveToLocal()
    }
    
    func removeFromList(display: DisplayData) {
        var removeIdx = -1
        for (index, item) in self.watchlist.enumerated() {
            if display.id == item.id {
                removeIdx = index
            }
        }
        if removeIdx == -1 {
            return
        }
        withAnimation(.default) {
            self.watchlist.remove(at: removeIdx)
            
        }
        self.saveToLocal()
    }
    
    func inWatchlist(display: DisplayData) -> Bool{
        for item in self.watchlist {
            if (display.id  == item.id) {
                return true
            }
        }
        return false
    }
    
    func saveToLocal() {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(self.watchlist)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "watchlist")

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func loadFromLocal() {
        if let data = UserDefaults.standard.data(forKey: "watchlist") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                self.watchlist = try decoder.decode([DisplayData].self, from: data)
                debugPrint(self.watchlist)

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
}

var watchListTest = [
   DisplayData(id: 791373, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020"),
   DisplayData(id: 2, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/6Wdl9N6dL0Hi0T1qJLWSz6gMLbd.jpg", type: "movie", date: "2020"),
   DisplayData(id: 3, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/6vcDalR50RWa309vBH1NLmG2rjQ.jpg", type: "movie", date: "2020"),
   DisplayData(id: 4, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/b4gYVcl8pParX8AjkN90iQrWrWO.jpg", type: "movie", date: "2020"),
   DisplayData(id: 5, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/lPsD10PP4rgUGiGR4CCXA6iY0QQ.jpg", type: "movie", date: "2020"),
]
