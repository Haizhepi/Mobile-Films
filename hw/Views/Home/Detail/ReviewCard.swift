//
//  ReviewCard.swift
//  hw
//
//  Created by Josh Liu on 4/26/21.
//

import SwiftUI

struct ReviewCard: View {
    var author: String
    var date: String
    var score: Float
    var content: String
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Spacer()
            }
            Text("A review by \(author)").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.title3)
            Text("Written by \(author) on \(date)").font(.subheadline).foregroundColor(.gray)
            HStack {
                Image(systemName: "star.fill").foregroundColor(.red)
                Text(String(format:"%.01f/5.0", self.score / 2))
                          .font(.headline)
            }.padding(.vertical, 3)
            
            Text(content).lineLimit(3).font(.callout)

        }.frame(height: 160).padding(.bottom, 4).padding(.horizontal, 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct ReviewCard_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCard(author: "haizhepi", date: "2020", score: 4.0, content: "loremdfaklsdjfksjah sdfjhaskjdhf fasdfjahsdfkjahsdvba dfas df awdsvakv dfas dvas dfadjsnvoajfdh asdf asvaesf asdv awdfa sdf asdf avdad fadf adf ")
    }
}
