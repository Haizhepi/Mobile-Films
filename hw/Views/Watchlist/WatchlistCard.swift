//
//  WatchlistCard.swift
//  hw
//
//  Created by Josh Liu on 4/27/21.
//

import SwiftUI
import Kingfisher

struct WatchlistCard: View {
    var display: DisplayData
    var body: some View {
        KFImage(URL(string: display.poster_path)).resizable().aspectRatio(contentMode: .fit)
    }
}

struct WatchlistCard_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistCard(display: getTestData()[0])
    }
}
