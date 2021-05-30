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
    
    
    var body: some View {
        
        ScrollView{
            if DoList.data.isEmpty {
                VStack{
                    Spacer()
                    Text(DoList.data.isEmpty ? "No data!" : "no")
                    Spacer()
                }
            } else {
                ForEach(DoList.data) { i in
                    DoView(data: i)
                        .onTapGesture{
                            showMake = true
                        }
                        .sheet(isPresented: $showMake) {
                            MakeView(showMake: $showMake)
                        }
                }
                .padding(0)
            }
        }
        .navigationTitle("Do List")
        .navigationBarHidden(true)        
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
        HomeView()
    }
}
