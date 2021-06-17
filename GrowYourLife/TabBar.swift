//
//  TabBar.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/22.
//

import SwiftUI

struct TabBar: View {
    @StateObject var viewModel = AuthenticationViewModel()
    @State var showMake = false
    @State var showProfile = false
    @State var viewState = CGSize.zero
    var body: some View {
        ZStack {
                        
            TabView{
                NavigationView{
                    ZStack{
                    Color("Background 2")
                        .edgesIgnoringSafeArea(.all)

                    HomeView(showProfile: $showProfile)
                        .background(
                            VStack {
                                LinearGradient(gradient: Gradient(colors: [Color("Background 2"), Color("Background 1")]), startPoint: .top, endPoint: .bottom)
                                    .frame(height: 200)
                                Spacer()
                            }
                            .background(Color("Background 1"))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: showProfile ? 30 : 0, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                        .offset(y: showProfile ? -450 : 0)
                        .rotation3DEffect(Angle(degrees: showProfile ? Double(viewState.height / 10) - 10 : 0), axis: (x: 10.0, y: 0, z: 0))
                        .scaleEffect(showProfile ? 0.9 : 1)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                        
                        MenuView(showProfile: $showProfile)
                            .background(Color.black.opacity(0.001))
                            .offset(y: showProfile ? 0 : screen.height)
                            .offset(y: viewState.height)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                            .onTapGesture {
                                self.showProfile.toggle()
                        }
                        .gesture(
                            DragGesture().onChanged { value in
                                self.viewState = value.translation
                            }
                            .onEnded { value in
                                if self.viewState.height > 50 {
                                    self.showProfile = false
                                }
                                self.viewState = .zero
                            }
                        )
                        
                }
                }.tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                
                NavigationView{
                    CharView()
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

let screen = UIScreen.main.bounds

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
