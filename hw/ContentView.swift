//
//  ContentView.swift
//  hw
//
//  Created by Josh Liu on 4/21/21.
//

import SwiftUI

extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}

struct ContentView: View {
    @StateObject var observed = Observer()
    @StateObject var watchlistData = WatchlistModel()

    @State private var selection: Tab = .home
    @State private var isMovie: Bool = true
    
    @State private var showToast: Bool = false

    
    enum Tab {
        case watchlist
        case home
        case search
        case loading
    }

    
    var body: some View {
            TabView(selection: $selection) {

                Search(showToast: $showToast, watchlistData: watchlistData)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(Tab.search)

                Home(nowMovies: observed.nowMovies, topRatedMovies: observed.topRatedMovies, popularMovies: observed.popularMovies, airingTVs: observed.airingTVs, topRatedTVs: observed.topRatedTVs, popularTVs: observed.popularTVs, watchlistData: watchlistData, showToast: $showToast, loadingProgress: observed.loadingProgress)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Tab.home)
                Watchlist(watchlistData: watchlistData, showToast: $showToast)
                    .tabItem {
                        Label("WatchList", systemImage: "heart")
                    }
                    .tag(Tab.watchlist)
            }.onAppear(perform: fetch)
            .ignoresSafeArea()
            
    }
    private func fetch() {
        observed.getNowMovies()
        observed.getTopRatedMovies()
        observed.getPopularMovies()
        observed.getAiringTVs()
        observed.getTopRatedTVs()
        observed.getPopularTVs()
        watchlistData.loadFromLocal()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
