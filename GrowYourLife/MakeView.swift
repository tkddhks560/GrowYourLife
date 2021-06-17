//
//  MakeView.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/23.
//

import SwiftUI
import Firebase

struct MakeView: View {
    @Binding var showMake: Bool
    @State var title = ""
    @State var subtitle = ""
    @State var selections: [String] = []
    @State var isTapped1 = false
    @State var isTapped2 = false
    @State var time = Date()
    @State var time2 = Date()
    @State var alarm = ""
    @State var checkday = ""
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var items: [String] = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday","Every Sunday"]
    @State var days: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    
    let db = Firestore.firestore()
    
    func saveData() {
        let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
        
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        alarm += String(hour) + String(minute)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //        time2 = dateFormatter.date(from: alarm)!
        db.collection("user").document(viewModel.userid).getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("user").document(viewModel.userid).updateData([
                    "title" : title,
                    "subtitle" : subtitle,
                    "checkday" : checkday,
                ])
            } else {
                db.collection("user").document(viewModel.userid).setData([
                    "id" : "",
                    "title" : title,
                    "subtitle" : subtitle,
                    "grade" : 0,
                    "points" : 0,
                    "image" : "tree_0_0",
                    "date": Date(),
                    "checkday": checkday,
                    "continueday" : 0,
                    "firstday" : "",
                    "done" : false
                ])
            }
        }
    }
    
    func deleteData() {
        db.collection("user").document(viewModel.userid).delete() { error in
            if let error = error {
                print("Error   \(viewModel.userid) \(error.localizedDescription)")
            }
            else {
                print("deleted \(viewModel.userid).")
            }
        }
    }

    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Spacer()
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .padding(.top, 10)
                        .onTapGesture {
                            deleteData()
                            showMake = false
                        }
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .padding(.top, 10)
                        .onTapGesture {// save date, so all components use the same date
                            saveData()
                            showMake = false
                        }
                }
                VStack(spacing: 25) {
                    TextField("", text: $title) { (status) in
                        if status {
                            withAnimation(.easeIn){
                                isTapped1 = true
                            }
                        }
                    } onCommit: {
                        if title == ""{
                            withAnimation(.easeOut) {
                                isTapped1 = false
                            }
                        }
                    }
                    .padding(.top, isTapped1||title != "" ? CGFloat(15) : 0)
                    .background(
                        Text("할 것")
                            .scaleEffect(isTapped1||title != "" ? 0.8 : 1)
                            .offset(x:isTapped1||title != "" ? -7 : 0, y:isTapped1||title != "" ? -15 : 0)
                            .foregroundColor(.gray)
                        , alignment: .leading
                    )
                    Divider()
                    
                    TextField("", text: $subtitle) { (status) in
                        if status {
                            withAnimation(.easeIn){
                                isTapped2 = true
                            }
                        }
                    } onCommit: {
                        if subtitle == "" {
                            withAnimation(.easeOut) {
                                isTapped2 = false
                            }
                        }
                    }
                    
                    .padding(.top, isTapped2||subtitle != "" ? CGFloat(15) : 0)
                    .background(
                        Text("세부 내용")
                            .scaleEffect(isTapped2||subtitle != "" ? 0.8 : 1)
                            .offset(x:isTapped2||subtitle != "" ? -7 : 0, y:isTapped2||subtitle != "" ? -15 : 0)
                            .foregroundColor(.gray)
                        , alignment: .leading
                    )
                    Divider()
                    
                    DatePicker("알림 시간", selection: $time, displayedComponents: .hourAndMinute)
                    
                    
                    NavigationLink(
                        destination: DayPickerView(selections: $selections, checkday: $checkday),
                        label: {
                            Text("요일 설정")
                                .padding()
                                .background(Color.gray.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        })
                    HStack(spacing: 20) {
                        ForEach(items.indices) { index in
                            Text(days[index])
                                .font(.system(size: 25))
                                .fontWeight(selections.contains(items[index])||checkday.contains("\(index)") ? .bold : .thin)
                                .foregroundColor(selections.contains(items[index])||checkday.contains("\(index)") ? .blue : .gray)
                                .scaleEffect(selections.contains(items[index])||checkday.contains("\(index)") ? 1.2 : 0.8)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            .navigationBarHidden(true)
            
        }
        
    }
}

struct MakeView_Previews: PreviewProvider {
    static var previews: some View {
        MakeView(showMake: .constant(true))
    }
}
