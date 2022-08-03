//
//  TextField.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 28.07.2022.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var focusTextField: FocusState<Bool>.Binding
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .font(Font.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Color("PlaceholderColor"))
                
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .focused(self.focusTextField)
                .font(Font.custom("Poppins-Regular", size: 12))
                .foregroundColor(Color("TextColor"))
        }
    }
}
