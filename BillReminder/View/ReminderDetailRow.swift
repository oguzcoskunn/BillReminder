//
//  ReminderDetailRow.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 2.08.2022.
//

import SwiftUI

struct ReminderDetailRow: View {
    let title: Text
    let text: Text
    
    var body: some View {
        ZStack(alignment: .center) {
            Color("HamburgerMenuBackgroundColor")
            
            HStack {
                title
                    .foregroundColor(Color("TextColor"))
                    .font(Font.custom("Poppins-Medium", size: 14))
                
                Spacer()
                
                text
                    .foregroundColor(Color("PlaceholderColor"))
                    .font(Font.custom("Poppins-Regular", size: 12))
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 55)
        .cornerRadius(8)
    }
}

