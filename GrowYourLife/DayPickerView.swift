//
//  DayPickerView.swift
//  GrowYourLife
//
//  Created by lsw on 2021/05/23.
//

import SwiftUI

struct DayPickerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var items: [String] = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday","Every Sunday"]
    @Binding var selections: [String]
    @Binding var checkday: String
    var body: some View {
        VStack {
            List {
                ForEach(self.items, id: \.self) { item in
                    MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                        if self.selections.contains(item) {
                            self.selections.removeAll(where: { $0 == item })
                        }
                        else {
                            self.selections.append(item)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            checkday = ""
            checkDay()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left.circle")
                Text("Go Back")
            }
        })
    }
    
    
    func checkDay() {
        var temp = 0
        for day in selections {
            temp = items.firstIndex(of: day)!
            checkday += "\(temp)"
        }
    }
}


struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
//
//struct DayPickerView_Previews: PreviewProvider {
//    @State var selections: [String] = []
//    static var previews: some View {
//        DayPickerView(selections: $selections)
//    }
//}
