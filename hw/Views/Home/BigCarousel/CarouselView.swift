//
//  CarouselView.swift
//  hw
//
//  Created by Josh Liu on 4/22/21.
//

import SwiftUI
import Kingfisher
import Combine

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

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
                        RemoteImage(url: display.poster_path).blur(radius: 4, opaque: true).frame(width:UIScreen.screenWidth - 15, height: 300)
                        RemoteImage(url: display.poster_path).aspectRatio(contentMode: .fit).frame( height: 300)
                    }
                    }
                }
                }
            .animation(.easeIn(duration: 0.2))
            .offset(x: CGFloat(self.currentIndex) * -UIScreen.screenWidth
, y: 0)
            .frame(width: UIScreen.screenWidth - 30, height: 300, alignment: .leading)

            .onReceive(self.timer) { _ in
                self.currentIndex = (self.currentIndex + 1) % self.displayData.count
            }
    }
    

}
