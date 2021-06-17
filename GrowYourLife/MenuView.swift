//
//  MenuView.swift
//  GrowYourLife
//
//  Created by 이상완 on 2021/06/18.
//

import SwiftUI

struct MenuView: View {
    
    @Binding var showProfile: Bool
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("\(viewModel.useremail) - 모앱2 기말 프로젝트")
                    .font(.caption)
                                
                MenuRow(title: "계정 정보", icon: "gear")
                MenuRow(title: "로그 아웃", icon: "person.crop.circle")
                    .onTapGesture {
                        UserDefaults.standard.set(false, forKey: "isLogIn")
                        self.viewModel.isLogIn = false
                        self.showProfile = false
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            .overlay(
                Image("Avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .offset(y: -150)
            )
        }
        .padding(.bottom, 30)

    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showProfile: .constant(false))
    }
}

struct MenuRow: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .light))
                .imageScale(.large)
                .frame(width: 32, height: 32)
                .foregroundColor(Color(#colorLiteral(red: 0.662745098, green: 0.7333333333, blue: 0.831372549, alpha: 1)))
            
            Text(title)
                .font(.system(size: 20, weight: .medium, design: .default))
                .frame(width: 120, alignment: .leading)
        }
    }
}
