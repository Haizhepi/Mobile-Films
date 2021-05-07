//
//  CastAvatar.swift
//  hw
//
//  Created by Josh Liu on 4/26/21.
//

import SwiftUI
import Kingfisher

struct CastAvatar: View {
    
    var avatarURL: String
    var castName: String
    
    @ViewBuilder
    var body: some View {
        VStack {
            if self.avatarURL == "" {
                Image("cast_placeholder").resizable()
                    .aspectRatio(contentMode: .fill)
                      .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            else {
                KFImage(URL(string: self.avatarURL))
                      .resizable()
                    .aspectRatio(contentMode: .fill)
                      .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
        
            Text(castName).font(.subheadline).lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
        }.frame(width: 100)
    }
}

struct CastAvatar_Previews: PreviewProvider {
    static var previews: some View {
        CastAvatar(avatarURL: "https://image.tmdb.org/t/p/w500/yzfxLMcBMusKzZp9f1Z9Ags8WML.jpg", castName: "Hadfdsfddfsdfgdfgdfgdfghaha")
    }
}
