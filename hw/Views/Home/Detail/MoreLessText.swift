//
//  MoreLessText.swift
//  hw
//
//  Created by Josh Liu on 4/26/21.
//

import SwiftUI

struct MoreLessText: View {
    var text: String
    @State private var showingSheet = false

        var body: some View {
            VStack (alignment: .trailing){
                if showingSheet {
                    Text(text).lineLimit(nil).font(.subheadline)
                }
                else {
                    Text(text).lineLimit(3).font(.subheadline)
                }
                if showingSheet {
                    Button("show less") {
                        withAnimation {
                            self.showingSheet.toggle()
                        }                    }.foregroundColor(.gray)
                }
                else {
                    Button("show more") {
                        withAnimation {
                            self.showingSheet.toggle()
                        }
                    }.foregroundColor(.gray)
                }
                
            }
            
        }
}

struct MoreLessText_Previews: PreviewProvider {
    static var previews: some View {
        MoreLessText(text: "fsd fasdf asfv awesvasfa sdf asdv asef asd vasd vas dafjahsdf vasdf asd awvwfv fds vasdv asdf asd vawsd afs dv asdva sdfas dfa sdffdsf asdfasdf sad fasdf asdf asdf asdfas ddfas dfasdf asf sdf sddf asdfa sdf asdfasdfas fasdfas ")
    }
}
