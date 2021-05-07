//
//  FullReview.swift
//  hw
//
//  Created by Josh Liu on 4/27/21.
//

import SwiftUI

struct FullReview: View {
    var title: String
    var review: ReviewData
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                Text(self.title).font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("By \(self.review.author) on \(review.date)").font(.title3).foregroundColor(.gray)
                HStack {
                    Image(systemName: "star.fill").foregroundColor(.red)
                    Text(String(format:"%.01f/5.0", self.review.score / 2))
                              .font(.headline)
                }.padding(.vertical, 3)
                Divider()
                Text(self.review.content)
                Spacer()

            }.padding(.all)
        }
    }
}

struct FullReview_Previews: PreviewProvider {
    static var previews: some View {
        FullReview(title: "String title", review: ReviewData(id: 1, author: "Haizhepi", date: "2020", score: 1.0, content: "dfkladsjfsadf asdf asdbasdf adsv aef awdsg vagwdfvasdjhvadf adg vaedfg vadsfbv arf adsg vafdg aefg adf gsd gsdfv serf s rtreg dsg"))
    }
}
