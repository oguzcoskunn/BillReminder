//
//  TextFieldRow.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 28.07.2022.
//

import SwiftUI

struct TextFieldRow: View {
    var title: Text
    var placeholder: Text
    @Binding var text: String
    @FocusState private var focusTextField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            title
                .font(Font.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color("TextColor"))
            ZStack(alignment: .topLeading) {
                Color("TextfieldBackgroundColor")
                
                CustomTextField(placeholder: self.placeholder, text: self.$text, focusTextField: self.$focusTextField)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
            }
            .onTapGesture {
                self.focusTextField = true
            }
            .frame(height: 67)
            .cornerRadius(8)
        }
    }
}

