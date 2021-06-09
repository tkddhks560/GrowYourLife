//
//  DoView.swift
//  GrowYourLife
//
//  Created by Euijoon Choi on 2021/05/22.

import SwiftUI
import Firebase

struct DoView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var isClick = false
    @State var data: UserData
    
    func getday() -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "e"
        
        return dateFormat.string(from: Date())
    }
    
    
    var body: some View {
        
        HStack {
            Image("tree_0_\(data.grade)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height: 100)
            
            VStack(alignment: .leading) {
                Text(data.title)
                    .font(.title)
                Text(data.subtitle)
                    .font(.subheadline)
                Text(getday())
                HStack {
                    Color.blue
                        .frame(width: CGFloat((data.points * 30)),height:10)
                        .animation(.easeIn)
                        .cornerRadius(20)
                    Spacer()
                    Text("\(isClick ? data.points : 0)/5")
                }
            }
            Spacer()
            Image(systemName: isClick ? "checkmark.circle.fill" : "checkmark.circle")
                .foregroundColor(.blue)
                .font(.system(size: 30))
                .onTapGesture {
                    isClick = true
                    data.points += 1
                    let db = Firestore.firestore()
                    db.collection("user").document(viewModel.userid).updateData(["points": data.points, "done" : true])
                }
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
    }
}

struct DoView_Previews: PreviewProvider {
    static var previews: some View {
        DoView(data: .init(id1: "", title: "", subtitle: "", points: 0, grade: 0, image: "tree_0_0", maxday: 0, checkday: "", continueday: 0, firstday: "", done: false, date: ""))
    }
}

func check() {
    
}

struct UserData: Identifiable {
    var id = UUID()
    var id1: String
    var title: String
    var subtitle: String
    var points: Int
    var grade: Int
    var image: String
    var maxday: Int
    var checkday: String
    var continueday: Int
    var firstday: String
    var done: Bool
    var date: String
}
