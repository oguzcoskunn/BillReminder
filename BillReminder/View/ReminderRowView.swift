//
//  ReminderRowView.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 1.08.2022.
//

import SwiftUI

struct ReminderRowView: View {
    let dayDiff: Int
    let reminderTitle: String
    let reminderInfo: String
    let reminderDate: Date
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(self.dayDiff <= 7 ? Color(#colorLiteral(red: 0.9333333373069763, green: 0.8392156958580017, blue: 0.27843138575553894, alpha: 1)) : Color(#colorLiteral(red: 0.49803921580314636, green: 0.8941176533699036, blue: 0.6235294342041016, alpha: 1)))
            .frame(width: 5, height: 67)
            
            ZStack {
                Color("TextfieldBackgroundColor")
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(reminderTitle)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("TextColor"))
                            .font(Font.custom("Poppins-Medium", size: 14))
                        Spacer()
                        Text(self.dayDiff == 0 ? "Today" : self.dayDiff > 1 ? "\(dayDiff) days" : "\(dayDiff) day")
                            .fixedSize()
                            .foregroundColor(self.dayDiff <= 7 ? Color(#colorLiteral(red: 0.93, green: 0.84, blue: 0.28, alpha: 1)) : Color(#colorLiteral(red: 0.5, green: 0.89, blue: 0.62, alpha: 1)))
                            .font(Font.custom("Poppins-Regular", size: 14))
                    }
                    
                    HStack {
                        Text(reminderInfo)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(#colorLiteral(red: 0.62, green: 0.62, blue: 0.62, alpha: 1)))
                            .font(Font.custom("Poppins-Regular", size: 12))
                        Spacer()
                        Text(self.reminderDate.formatted(as: "dd.MM.yyyy"))
                            .fixedSize()
                            .foregroundColor(Color("TextColor"))
                            .font(Font.custom("Poppins-Regular", size: 12))
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 67)
        }
        .cornerRadius(8)
    }
}
