//
//  CarouselView.swift
//  hw
//
//  Created by Josh Liu on 4/22/21.
//

import SwiftUI
import Kingfisher
import Combine

struct CarouselView: View {
    @State private var currentIndex: Int = 0
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var displayData: [DisplayData]
    var watchlistData: WatchlistModel
    @Binding var showToast: Bool

    var body: some View {
            HStack(spacing: 15) {
                ForEach(self.displayData) {
                    display in
                    NavigationLink(destination: Detail(data: display, watchlistData: watchlistData, showToast: $showToast)) {

                    ZStack {
                        RemoteImage(url: display.poster_path).blur(radius: 4, opaque: true).frame(width:360, height: 300)
                        RemoteImage(url: display.poster_path).aspectRatio(contentMode: .fit).frame( height: 300)
//                        KFImage(URL(string: display.poster_path)).resizable().blur(radius:4).frame(width:360, height: 300)
//                            KFImage(URL(string: display.poster_path))
//                                .resizable().aspectRatio(contentMode: .fit).frame( height: 300)
                    }
                    }
                }
                }
            .animation(.easeIn(duration: 0.2))
            .offset(x: CGFloat(self.currentIndex) * -375, y: 0)
            .frame(width: 360, height: 300, alignment: .leading)

            .onReceive(self.timer) { _ in
                self.currentIndex = (self.currentIndex + 1) % self.displayData.count
            }
    }
    

}
