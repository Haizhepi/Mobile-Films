//
//  CardItem.swift
//  hw
//
//  Created by Josh Liu on 4/23/21.
//

import SwiftUI
import Kingfisher



struct CardItem: View {
    @Environment(\.openURL) var openURL
    var display: DisplayData
    var watchlistData: WatchlistModel
    @State var inWatchlist: Bool = false
    @Binding var showToast: Bool

    
    private func check() {
        self.inWatchlist = self.watchlistData.inWatchlist(display: self.display)
    }
    @ViewBuilder
    var body: some View {
            ZStack (alignment: .top){
                    Rectangle()
                        .fill(Color.white)
                    VStack(alignment: .center) {
                        if display.poster_path == "" {
                            Image("movie_placeholder").resizable().cornerRadius(15).aspectRatio(contentMode: .fill)
                        }
                        else {
                            RemoteImage(url: display.poster_path).cornerRadius(15).aspectRatio(contentMode: .fill)
                        }
//                        KFImage(URL(string: display.poster_path)).resizable().cornerRadius(15).aspectRatio(contentMode: .fill)
                        Text(display.title)
                            .foregroundColor(.primary)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        if display.date != "" {
                            Text("(\(display.date))")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        
                    }

                }
            .contentShape(RoundedRectangle(cornerRadius: 15))
                .contextMenu {
                    if self.inWatchlist {
                        Button {
                            self.inWatchlist.toggle()
                            watchlistData.removeFromList(display: self.display)
                            watchlistData.toastMessage = "\(self.display.title) is removed from watchlist"
                            withAnimation {
                                self.showToast = true
                            }
                            
                        } label: {
                            Label("Remove from Watch List", systemImage: "bookmark.fill")
                        }
                    }
                    else {
                        Button {
                            watchlistData.addToList(display: self.display)
                            self.inWatchlist.toggle()
                            watchlistData.toastMessage = "\(self.display.title) is added in watchlist"

                            withAnimation {
                                self.showToast = true
                            }

                        } label: {
                            Label("Add to Watch List", systemImage: "bookmark")

                        }
                    }
                    Button {
                        let shareString = "https://www.facebook.com/sharer/sharer.php?u=" +
                            "https://www.themoviedb.org/\(self.display.type)/\(self.display.id)"
                        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        openURL(URL(string: escapedShareString)!)

                    } label: {
                        Label("Share on FaceBook", image: "facebook-app-symbol")
                    }
                    
                    Button {
                        let shareString = "https://twitter.com/intent/tweet?text=Check out this link: https://www.themoviedb.org/\(self.display.type)/\(self.display.id)#CSCI571USCFilms"
                        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        openURL(URL(string: escapedShareString)!)
                    } label: {
                        Label("Share on Twitter", image: "twitter")
                    }
            }.onAppear(perform: self.check)
            .frame(width: 104)
            .aspectRatio(contentMode: .fit)
    }

}
