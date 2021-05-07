//
//  SearchBar.swift
//  hw
//
//  Created by Josh Liu on 4/23/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    @Binding var searchResult : [SearchData]
    @Binding var noResult: Bool


    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        @Binding var searchResult : [SearchData]
        @Binding var noResult: Bool

        
        var searchString: String = ""
        @ObservedObject var observed = Observer()
        let debouncer = Debouncer(delay: 1.0)


        init(text: Binding<String>, searchResult: Binding<[SearchData]>, noResult: Binding<Bool>) {
            _text = text
            _searchResult = searchResult
            _noResult = noResult
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           searchBar.setShowsCancelButton(true, animated: true)

        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = nil
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            self.searchResult = []
            self.noResult = false
            self.text = ""
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            debouncer.run(action: {
                self.getSearch(str: searchText)
            })
            
            self.text = searchText
        }
        
        func getSearch(str: String) {
            if str.count >= 3 {
                self.searchResult = []
                let processed = str.replacingOccurrences(of: " ", with: "%20")
                AF.request(url + "/search/multi/" + processed, method: .get).responseData{
                    (data) in
                    let json = try! JSON(data: data.data!)
                    for token in json["data"].arrayValue {
                        if token["backdrop_path"].stringValue != "" {
                            self.noResult = false
                            self.searchResult.append(self.getSearchData(token: token))
                        }
                    }
                    if self.searchResult.count == 0 {
                        self.noResult = true
                    }
                }
            }
        }
        
        private func getSearchData(token: JSON) -> SearchData {
            let id = token["id"].intValue
            let title = token["title"].stringValue
            let poster_path = token["poster_path"].stringValue
            let backdrop_path = token["backdrop_path"].stringValue

            var date = token["date"].stringValue
            let media_type = token["media_type"].stringValue
            let vote_average = token["vote_average"].floatValue
            if (date.count > 4) {
                date = String(date.prefix(4))
            }
            let res = SearchData(id: id, title: title, poster_path: poster_path, backdrop_path: backdrop_path, type: media_type, date: date, vote_average: vote_average)
            return res
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, searchResult: $searchResult, noResult: $noResult)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search Movies, TVs..."
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
   
    
    
}
//
//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar()
//    }
//}
