//
//  Search.swift
//  hw
//
//  Created by Josh Liu on 4/21/21.
//

import SwiftUI


struct Search: View {

    @State private var searchText : String = ""
    @State private var searchTextDisplay : String = ""
    @State private var noResult: Bool = false
    @State private var searchResult : [SearchData] = []
    @Binding var showToast: Bool

    var watchlistData: WatchlistModel
    
    var body: some View {
        NavigationView {
                   VStack {
                    SearchBar(text: $searchText, searchResult: $searchResult, noResult: $noResult)
                
                    ScrollView {
                        if searchResult.count > 0 {
                            VStack {

                                    ForEach(searchResult) {
                                            res in
                                        NavigationLink(destination: Detail(data: DisplayData(id: res.id, title: res.title, poster_path: res.poster_path, type: res.type, date: res.date), watchlistData: watchlistData, showToast: $showToast)) {
                                        SearchCard(searchData: res)
                                        }
                                    }
                                
                            }.padding(.horizontal)
                        }
                        else if noResult{
                            Text("No Results").font(.title).foregroundColor(.gray)
                        }
                        
                    }
                        Spacer()
                   }.navigationBarTitle(Text("Search"))
               }
    }
    
    
}


