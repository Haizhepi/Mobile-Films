//
//  Detail.swift
//  hw
//
//  Created by Josh Liu on 4/26/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

let DEVURL = "http://localhost:8080"
let PRODURL = "http://52.32.174.98:8080"
let url = "http://571hw9-env.eba-2qmy2pwq.us-west-2.elasticbeanstalk.com"

struct DetailData {
    public var genres: [String]
    public var spoken_anguages: [String]
    public var overview: String
    public var vote_average: Float
    public var date: String
}

struct CastData : Identifiable{
    public var id: Int
    public var name: String
    public var poster_path: String
}

struct ReviewData : Identifiable{
    public var id: Int
    public var author: String
    public var date: String
    public var score: Float
    public var content: String
}


struct Detail: View {
    @Environment(\.openURL) var openURL

    var data: DisplayData
    var watchlistData: WatchlistModel
    @State private var detailData: DetailData = DetailData(genres: [], spoken_anguages: [], overview: "overview", vote_average: 1.0, date: "2020")
    @State private var casts: [CastData] = [CastData]()
    @State private var reviews: [ReviewData] = [ReviewData]()
    @State private var recommend: [DisplayData] = [DisplayData]()
    @State private var videoId: String = ""

    @State var inWatchlist: Bool = false
    @Binding var showToast: Bool
    
    @State var loading: Int = 0
    
    private func check() {
        self.inWatchlist = self.watchlistData.inWatchlist(display: self.data)
    }
    @ViewBuilder
    var body: some View {
        
        if self.loading < 5 {
            VStack {
                ProgressView()
                Text("Fetching Data...").font(.subheadline).foregroundColor(.gray)
            }
            .onAppear(perform: {
                check()
                fetch()
            })
        }
        else {
            ScrollView {
                VStack (alignment: .leading){
                    if self.videoId != "" {
                        YtbView(videoID: self.videoId).frame(height: 200)
                    }
                    Group {
                        Text(data.title).font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text(data.date + " | \(self.detailData.genres.joined(separator: ", "))").font(.body).padding(.top, 5)
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.red)
                            Text(String(format:"%.01f/5.0", self.detailData.vote_average / 2))
                                .font(.body)
                        }.padding(.vertical, 3)
                            MoreLessText(text: self.detailData.overview)
                    }
                    if self.casts.count > 0 {
                        Text("Cast & Crew").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(self.casts) { cast in
                                    CastAvatar(avatarURL: cast.poster_path, castName: cast.name)
                                }
                            }
                        }
                    }
                    if self.reviews.count > 0 {
                        Text("Reviews").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        ForEach(self.reviews) { review in
                            NavigationLink(
                                destination: FullReview(title: self.data.title, review: review)
                                ) {
                                ReviewCard(author: review.author, date: review.date, score: review.score, content: review.content)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                    if self.recommend.count > 0 {
                        CardGroup(title: "Recommended \(self.data.type)s", displays: self.recommend, watchlistData: watchlistData, showToast: $showToast)
                    }
                    Spacer()
                }.padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                        Text("")
                    }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        if self.inWatchlist {
                            Button(action: {
                                self.inWatchlist.toggle()
                                watchlistData.removeFromList(display: self.data)
                                watchlistData.toastMessage = "\(self.data.title) is removed from watchlist"
                                withAnimation {
                                    self.showToast = true
                                }
                            }) {
                                Image(systemName: "bookmark.fill")
                            }
                        }
                        else {
                            Button(action: {
                                self.inWatchlist.toggle()
                                watchlistData.addToList(display: self.data)
                                watchlistData.toastMessage = "\(self.data.title) is added in watchlist"
                                withAnimation {
                                    self.showToast = true
                                }
                            }) {
                                Image(systemName: "bookmark").foregroundColor(.black)                    }
                        }
                        Button(action: {
                            let shareString = "https://www.facebook.com/sharer/sharer.php?u=" +
                                "https://www.themoviedb.org/\(self.data.type)/\(self.data.id)"
                            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                            openURL(URL(string: escapedShareString)!)
                        }) {
                            Image("facebook-app-symbol").resizable().scaledToFit()
                        }
                        Button(action: {
                            let shareString = "https://twitter.com/intent/tweet?text=Check out this link: https://www.themoviedb.org/\(self.data.type)/\(self.data.id)#CSCI571USCFilms"
                            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                            openURL(URL(string: escapedShareString)!)
                        }) {
                            Image("twitter").resizable().scaledToFit()
                        }
                    }.frame(height: 20)
                }
            }.toast(isPresented: $showToast) {
                HStack(alignment: .center) {
                    Text(watchlistData.toastMessage).font(.subheadline).foregroundColor(.white).multilineTextAlignment(.center)
                }//HStack
            }
        }
        
        
    }
    
    func fetch() {
        self.getVideo()
        self.getDetail()
        self.getCasts()
        self.getReviews()
        self.getRecommend()
    }
    
    func getDetail() {
        AF.request(url + "/detail/detail_\(data.type)/\(data.id)", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"]["genres"].arrayValue {
                self.detailData.genres.append(token.stringValue)
            }
            for token in json["data"]["spoken_languages"].arrayValue {
                self.detailData.spoken_anguages.append(token["name"].stringValue)
            }
            self.detailData.overview = json["data"]["overview"].stringValue
            self.detailData.vote_average = json["data"]["vote_average"].floatValue
            if self.data.type == "movie" {
                self.detailData.date = json["data"]["release_date"].stringValue
            }
            else {
                self.detailData.date = json["data"]["first_air_date"].stringValue
            }
            self.loading += 1
        }
    }
    
    func getCasts() {
        AF.request(url + "/detail/cast_\(data.type)/\(data.id)", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            self.casts = []
            var actualNumberOfCasts = 0
            for token in json["data"].arrayValue {
                if token["profile_path"].stringValue != "" {
                    if actualNumberOfCasts < 10 {
                        self.casts.append(CastData(id: token["id"].intValue, name: token["name"].stringValue, poster_path: token["profile_path"].stringValue))
                        actualNumberOfCasts += 1
                    }
                }
            }
            self.loading += 1

        }
    }
    
    func getReviews() {
        AF.request(url + "/detail/reviews_\(data.type)/\(data.id)", method: .get).responseData{
            (data) in
            self.reviews = []
            let json = try! JSON(data: data.data!)
            for (index, token) in json["data"].arrayValue.enumerated() {
                if index < 3 {
                    self.reviews.append(ReviewData(id: index, author: token["author"].stringValue, date: token["created_at"].stringValue, score: token["rating"].floatValue, content: token["content"].stringValue))
                }
            }
            self.loading += 1

        }
    }
    
    func getVideo() {
        AF.request(url + "/detail/\(data.type)/videos/\(data.id)", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {

                if token["type"].stringValue == "Trailer" {
                    self.videoId = token["key"].stringValue.components(separatedBy: "?v=").last ?? "tzkWB85ULJY"
                    break
                }
                else if token["type"].stringValue == "Teaser" {
                    self.videoId = token["key"].stringValue.components(separatedBy: "?v=").last ?? "tzkWB85ULJY"
                    break
                }
            }
            self.loading += 1

        }
    }
    
    func getRecommend() {
        AF.request(url + "/detail/recommend_\(data.type)/\(data.id)", method: .get).responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for token in json["data"].arrayValue {
                self.recommend.append(Observer.getInfoDisplay(token: token, media_type: self.data.type))
            }
            self.loading += 1

        }

    }
}
