//
//  ContentView.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        if viewModel.isLogIn {
            TabBar()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
