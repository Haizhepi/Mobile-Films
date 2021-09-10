//
//  Home.swift
//  hw
//
//  Created by Josh Liu on 4/21/21.
//

import SwiftUI

struct Home: View {
    
    @State private var isMovie: Bool = true

    var nowMovies: [DisplayData]
    var topRatedMovies: [DisplayData]
    var popularMovies: [DisplayData]
    
    var airingTVs: [DisplayData]
    var topRatedTVs: [DisplayData]
    var popularTVs: [DisplayData]
    
    var watchlistData: WatchlistModel
    @Binding var showToast: Bool
    var loadingProgress: Int

    @ViewBuilder
    var body: some View {
        
        NavigationView {
            if loadingProgress < 6 {
                VStack {
                    ProgressView()
                    Text("Fetching Data...").font(.subheadline).foregroundColor(.gray)
                }
                
            }
            else
            if self.isMovie {
                ScrollView {
                    VStack(alignment: .leading){
                       
                        Text("Now Playing")
                            .font(.title2)
                            .fontWeight(.bold)

                        CarouselView(displayData: self.nowMovies, watchlistData: watchlistData, showToast: $showToast)
                        CardGroup(title: "Top Rated", displays: self.topRatedMovies, watchlistData: watchlistData, showToast: $showToast)
                        CardGroup(title: "Popular", displays: self.popularMovies, watchlistData: watchlistData, showToast: $showToast)
                        

                    }
                    VStack (alignment: .center){
                        Link("Powered by TMDB", destination: URL(string: "https://www.themoviedb.org/")!).font(.caption).foregroundColor(.gray)
                        Text("Developed by Josh Liu").font(.caption).foregroundColor(.gray)

                    }.padding(.bottom)
                    
                }
                .padding(.horizontal)
                .navigationBarTitle("USC Films")
                .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("TV Shows") {
                        self.isMovie.toggle()
                    }
                }
            }
                .toast(isPresented: $showToast) {
                    HStack(alignment: .center) {
                        Text(watchlistData.toastMessage).font(.subheadline).foregroundColor(.white).multilineTextAlignment(.center)
                    }//HStack

            }
            }
            else {
                ScrollView {
                    VStack(alignment: .leading){
                       
                        Text("Trending")
                            .font(.title2)
                            .fontWeight(.bold)

                        CarouselView(displayData: self.airingTVs, watchlistData: watchlistData, showToast: $showToast)
                        CardGroup(title: "Top Rated", displays: self.topRatedTVs, watchlistData: watchlistData, showToast: $showToast)
                        CardGroup(title: "Popular", displays: self.popularTVs, watchlistData: watchlistData, showToast: $showToast)
                    }
                    VStack (alignment: .center){
                        Link("Powered by TMDB", destination: URL(string: "https://www.themoviedb.org/")!).font(.caption).foregroundColor(.gray)
                        Text("Developed by Josh Liu").font(.caption).foregroundColor(.gray)

                    }.padding(.bottom)
                    
                }
                .padding(.horizontal)
                .navigationBarTitle("MY Films")
                .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Movies") {
                        self.isMovie.toggle()
                    }
                }
            }
                .toast(isPresented: $showToast) {
                    HStack(alignment: .center) {
                        Text(watchlistData.toastMessage).font(.subheadline).foregroundColor(.white).multilineTextAlignment(.center)
                    }//HStack
            }
                
            }
           
        }

    }
}
