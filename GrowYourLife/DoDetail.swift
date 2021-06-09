//
//  DoDetail.swift
//  GrowYourLife
//
//  Created by Euijoon Choi on 2021/05/31.
//

import SwiftUI

struct DoDetail: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("tree_0_0")
                
                Divider()
                
                Text("Do Title")
                Text("Do subtitle")
                Text("grade")
                Text("point")
                Text("date")
            }
        }
    }
}

struct DoDetail_Previews: PreviewProvider {
    static var previews: some View {
        DoDetail()
    }
}
