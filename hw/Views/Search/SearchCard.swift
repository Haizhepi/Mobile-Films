//
//  SearchCard.swift
//  hw
//
//  Created by Josh Liu on 4/24/21.
//

import SwiftUI
import Kingfisher


struct SearchCard: View {
    
    var searchData: SearchData
    
    var body: some View {
        ZStack {
            KFImage(URL(string: self.searchData.backdrop_path))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            VStack {
                HStack {
                    Text("\(self.searchData.type.uppercased())(\(self.searchData.date))")
                              .font(.headline)
                        .foregroundColor(Color.white).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Image(systemName: "star.fill").foregroundColor(.red)

                    Text(String(format:"%.01f", self.searchData.vote_average / 2))
                              .font(.headline)
                        .foregroundColor(Color.white)
                }.padding(.all)
                Spacer()
                HStack {
                    Text(self.searchData.title)
                              .font(.headline)
                        .foregroundColor(Color.white).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                }.padding(.all)
            }.frame(height: 180)
        }
        .frame(height:180)
        // Add clip shape to the whole ZStack
    
    }
}

struct SearchCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchCard(searchData: getOneSearchData())
    }
}
