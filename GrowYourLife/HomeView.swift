//
//  HomeView.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/22.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State var showMake = false
    @ObservedObject var DoList = getData()
    let db = Firestore.firestore()
    @State var number = 0
    @Binding var showProfile: Bool
    
    var body: some View {
        
        VStack {
            HStack{
                Text("진행중인 자기계발")
                    .font(.system(size: 28, weight: .bold))
                Spacer()
                Button(action: {showProfile.toggle()}) {
                Image(systemName: "person")
                    .foregroundColor(.primary)
                    .font(.system(size:16, weight: .medium))
                    .frame(width:36, height: 36)
                    .background(Color("Background 3"))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 25)
            
            
            ScrollView{
                if DoList.data.isEmpty {
                    VStack{
                        Spacer()
                        Text(DoList.data.isEmpty ? "진행 중인 자기 계발이 없습니다! 지금 시작하세요!" : "no")
                        Spacer()
                    }
                } else {
                    ForEach(DoList.data) { i in
                        DoView(data: i)
                            .onTapGesture{
                                showMake = true
                            }
                            .sheet(isPresented: $showMake) {
                                MakeView(showMake: $showMake, title: i.title, subtitle: i.subtitle, checkday: i.checkday)
                            }
                    }
                    .padding(0)
                }
            }
            .navigationBarHidden(true)
        }
        
    }
}


class getData: ObservableObject {
    
    @Published var data = [UserData]()
    @Published var noData = false
    
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("user").order(by: "date", descending: false).addSnapshotListener{ (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                self.noData = true
                return
            }
            
            if(snap?.documentChanges.isEmpty)! {
                self.noData = true
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    let id = i.document.documentID
                    let title = i.document.get("title") as! String
                    let subtitle = i.document.get("subtitle") as! String
                    let points = i.document.get("points") as! Int
                    let date = i.document.get("date") as! Timestamp
                    let image = i.document.get("image") as! String
                    let grade = i.document.get("grade") as! Int
//                    let maxday = i.document.get("maxday") as! Int
                    let continueday = i.document.get("continueday") as! Int
                    let firstday = i.document.get("firstday") as! String
                    let checkday = i.document.get("checkday") as! String
                    let done = i.document.get("done") as! Bool
                    let format = DateFormatter()
                    format.dateFormat = "dd-MM-YY hh:mm a"
                    let dateString = format.string(from: date.dateValue())
                    
                    self.data.append(UserData(id1: id, title: title, subtitle: subtitle, points: points,grade: grade, image: image, maxday: 0, checkday: checkday, continueday: continueday, firstday: firstday, done: done, date: dateString))
                }
                
                if i.type == .modified{
                    // when data is changed
                    let title = i.document.get("title") as! String
                    let subtitle = i.document.get("subtitle") as! String
                    
                    self.data[0].title = title
                    self.data[0].subtitle = subtitle
                    
                }
            }
        }
    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showProfile: .constant(false))
    }
}
