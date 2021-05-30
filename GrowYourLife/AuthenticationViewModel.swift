//
//  AuthenticationViewModel.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/22.
//

import GoogleSignIn
import Firebase

class AuthenticationViewModel: NSObject, ObservableObject{
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    @Published var isLogIn = false
    @Published var userid = ""
    @Published var isLoading = false
    override init() {
        super.init()
        
        setupGoogleSignIn()
    }
    
    
    func signIn() {
        if GIDSignIn.sharedInstance().currentUser == nil {
            
            GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    
    func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try Auth.auth().signOut()
            
            state = .signedOut
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }
    
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance()?.delegate = self
    }
}

extension AuthenticationViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            
            firebasAuthentication(withUser: user)
        }
        else {
            print(error.debugDescription)
        }
    }
    
    private func firebasAuthentication(withUser user: GIDGoogleUser) {
        self.isLoading = true
        if let authentication = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            self.state = .signedIn
            
            Auth.auth().signIn(with: credential) { (res, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.isLoading = false
                    self.isLogIn = true
                    self.state = .signedIn
//                    let db = Firestore.firestore()
                    self.userid = String((res?.user.uid)!)
//                    db.collection("user").document(String((res?.user.uid)!)).getDocument { (document, error) in
//                        if let document = document, document.exists {
//                            print("yes")
//                            self.userid = document.get("id") as! String
//                        } else {
//                            db.collection("user").document(String((res?.user.uid)!)).setData([
//                                "id" : String((res?.user.uid)!),
//                                "title" : "",
//                                "subtitle" : "",
//                                "grade" : 0,
//                                "points" : 0,
//                                "image" : "",
//                                "continueday" : 0,
//                                "firstday" : "",
//                                "done" : false
//                            ], merge: true)
//                            self.userid = String((res?.user.uid)!)
//                        }
//                    }
                }
            }
        }
    }
    
}
