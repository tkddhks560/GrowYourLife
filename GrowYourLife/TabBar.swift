//
//  TabBar.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/22.
//

import SwiftUI

struct TabBar: View {
    @State var showMake = false
    
    var body: some View {
        ZStack {
            TabView{
                NavigationView{
                    HomeView()
                }.tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("List")
                }
                
                NavigationView{
                    HomeView()
                }.tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("List")
                }
            }
            
            VStack {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.purple)
                    .font(.system(size: 60))
                    .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0.0, y: 10)
                    .offset(y: -10)
                    .onTapGesture {
                        self.showMake = true
                    }
                    .sheet(isPresented: $showMake) {
                        MakeView(showMake: $showMake)
                    }
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
