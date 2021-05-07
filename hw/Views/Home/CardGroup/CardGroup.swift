//
//  CardGroup.swift
//  hw
//
//  Created by Josh Liu on 4/23/21.
//

import SwiftUI

struct CardGroup: View {
    var title: String
    var displays: [DisplayData]
    var watchlistData: WatchlistModel
    @Binding var showToast: Bool


    var body: some View {
        VStack (alignment: .leading){
            Text(self.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.title)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 25) {
                    ForEach(displays) { display in
                        NavigationLink(destination: Detail(data: display, watchlistData: watchlistData, showToast: $showToast)) {
                            CardItem(display: display, watchlistData: watchlistData, showToast: $showToast)
                        }.buttonStyle(PlainButtonStyle())
                            
                    }
                }.aspectRatio(contentMode: .fit)

            }
        }
    }
}

