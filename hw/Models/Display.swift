//
//  Display.swift
//  hw
//
//  Created by Josh Liu on 4/21/21.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DisplayData : Identifiable, Codable {
    
    public var id: Int
    public var title: String
    public var poster_path: String
    public var type: String
    public var date: String

}

struct SearchData : Identifiable{
    
    public var id: Int
    public var title: String
    public var poster_path: String
    public var backdrop_path: String
    public var type: String
    public var date: String
    public var vote_average: Float

}

class Observer : ObservableObject{
    @Published var nowMovies = [DisplayData]()
    @Published var topRatedMovies = [DisplayData]()
    @Published var popularMovies = [DisplayData]()
    
    @Published var airingTVs = [DisplayData]()
    @Published var topRatedTVs = [DisplayData]()
    @Published var popularTVs = [DisplayData]()
    
    @Published var searchResult = [SearchData]()
    
    @Published var loadingProgress: Int = 0

    init() {
        
    }
    
    func getAiringTVs()
    {
        AF.request(url + "/info/tv/airing_today", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {
                self.airingTVs.append(Observer.getInfoDisplay(token: token, media_type: "tv"))
            }
            self.loadingProgress += 1
        }
    }
    
    func getTopRatedTVs()
    {
        AF.request(url + "/info/tv/top_rated", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {
                self.topRatedTVs.append(Observer.getInfoDisplay(token: token, media_type: "tv"))
            }
            self.loadingProgress += 1
        }
    }
    
    func getPopularTVs()
    {
        AF.request(url + "/info/tv/popular", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {
                self.popularTVs.append(Observer.getInfoDisplay(token: token, media_type: "tv"))
            }
            self.loadingProgress += 1
        }
    }
    
    func getNowMovies()
    {
        debugPrint(url + "/info/movie/now_playing")
        AF.request(url + "/info/movie/now_playing", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {
                self.nowMovies.append(Observer.getInfoDisplay(token: token, media_type: "movie"))
            }
            self.loadingProgress += 1
        }
    }
    
    func getTopRatedMovies() {
        AF.request(url + "/info/movie/top_rated", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {
                self.topRatedMovies.append(Observer.getInfoDisplay(token: token, media_type: "movie"))
            }
            self.loadingProgress += 1
        }
    }
    
    func getPopularMovies() {
        AF.request(url + "/info/movie/popular", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {
                self.popularMovies.append(Observer.getInfoDisplay(token: token, media_type: "movie"))
            }
            self.loadingProgress += 1
        }
    }
    
    func getSearch(str: String) {
        if str != "" {
            let processed = str.replacingOccurrences(of: " ", with: "%20")
            AF.request(url + "/search/multi/" + processed, method: .get).responseData{
                (data) in
                let json = try! JSON(data: data.data!)
                for token in json["data"].arrayValue {
                    self.searchResult.append(self.getSearchData(token: token))
                }
                print(self.searchResult[0])
                
            }
        }
    }
    
    private func getSearchData(token: JSON) -> SearchData {
        let id = token["id"].intValue
        var title = token["title"].stringValue
        if !token["title"].exists() {
            title = token["name"].stringValue
        }
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
    
    public static func getInfoDisplay(token: JSON, media_type: String) -> DisplayData{
        let id = token["id"].intValue
        var title = token["title"].stringValue
        if !token["title"].exists() {
            title = token["name"].stringValue
        }
        let poster_path = token["poster_path"].stringValue
        var date = token["date"].stringValue
        if (date.count > 4) {
            date = String(date.prefix(4))
        }
        let res = DisplayData(id: id, title: title, poster_path: poster_path, type: media_type, date: date)
        return res
    }
}

func getTestData() -> [DisplayData] {
    var arr = [DisplayData]()
    arr.append(DisplayData(id: 791373, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020"))
    arr.append(DisplayData(id: 2, title: "movie1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020"))
    arr.append(DisplayData(id: 3, title: "movie1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020"))
    arr.append(DisplayData(id: 4, title: "movie1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020"))
    arr.append(DisplayData(id: 5, title: "movidfsdfsasdfs e1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020"))
    return arr
}


func getSearchData() -> [SearchData] {
    var arr = [SearchData]()
    arr.append(SearchData(id: 1, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", backdrop_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020", vote_average: 4))
    return arr
}

func getOneSearchData() -> SearchData {
    return SearchData(id: 1, title: "mofsd afsd svie1", poster_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", backdrop_path: "https://image.tmdb.org/t/p/w500/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", type: "movie", date: "2020", vote_average: 4)
}
