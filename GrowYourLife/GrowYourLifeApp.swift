//
//  GrowYourLifeApp.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/22.
//

import SwiftUI
import Firebase
import GoogleSignIn


@main
struct GrowYourLifeApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    @UIApplicationDelegateAdaptor (Appdelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}

class Appdelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        
        return true
    }
    
}


