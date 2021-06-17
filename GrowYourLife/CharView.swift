//
//  CharView.swift
//  GrowYourLife
//
//  Created by 이상완 on 2021/06/10.
//

import SwiftUI


struct CharView: View {
    @ObservedObject var DoList = getData()
    var Temp = ["1","2","3","10"]
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                
                ForEach(Temp.indices) { index in
                    GeometryReader { geometry in
                            CardView(card: Temp[index])
                                
                                .rotation3DEffect(Angle(degrees:
                                                            Double(geometry.frame(in: .global).minX - 30) / -20
                                ), axis: (x: 0, y: 10, z: 0))
                                                }
                    .frame(width: 275, height: 275)
                    .padding(.leading, index == 0 ? 75 : 0)
                }
                
            }
        }
    }
}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        CharView()
    }
}


struct CardView: View {
//    var card: UserData
    var card : String
    var body: some View {
        Image("tree_0_\(card)")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:200, height: 200)
            .background(Color.black.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

