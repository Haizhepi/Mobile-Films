//
//  Watchlist.swift
//  hw
//
//  Created by Josh Liu on 4/21/21.
//

import SwiftUI

struct Watchlist: View {
    var watchlistData: WatchlistModel
    @Binding var showToast: Bool
    let columns = [
            GridItem(.flexible(), spacing: 5),
            GridItem(.flexible(), spacing: 5),
            GridItem(.flexible(), spacing: 5),
        ]
    @ViewBuilder
    var body: some View {
        if watchlistData.watchlist.count == 0 {
            VStack(alignment: .center) {
                Text("Watchlist is Empty").font(.title).foregroundColor(.gray)
            }
        }
        else {
            
        
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                    ForEach(watchlistData.watchlist) {
                        display in
                        NavigationLink(destination: Detail(data: display, watchlistData: watchlistData, showToast: $showToast)) {

                        WatchlistCard(display: display)
                            .onDrag({
                                        
                                        watchlistData.currentDisplay = display
                                return NSItemProvider(contentsOf: URL(string: "\(display.id)")!)! })
                            .onDrop(of: [.url], delegate: DropDelegateView(display: display, watchlistData: watchlistData))
                            .contextMenu {
                                Button {
                                    debugPrint(watchlistData.watchlist.count)
                                    watchlistData.removeFromList(display: display)
                                } label: {
                                    Label("Remove from Watch List", systemImage: "bookmark.fill")
                                }

                               
                        }
                        }.buttonStyle(PlainButtonStyle()) 
                    }
                }.padding()
            }.navigationBarTitle("Watchlist").onAppear(perform: {
                watchlistData.saveToLocal()
                watchlistData.loadFromLocal()
        })
        }

    }
    }
}

