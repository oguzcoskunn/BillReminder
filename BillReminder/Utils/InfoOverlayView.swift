//
//  s.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 29.07.2022.
//

import SwiftUI

struct InfoOverlayView: View {
    let infoMessage: String
    let buttonTitle: String
    let systemImageName: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack() {
                Text(infoMessage)
                    .foregroundColor(Color("TextColor"))
                    .font(Font.custom("Poppins-Medium", size: 15))
                    .multilineTextAlignment(.leading)
                Spacer()
                Button {
                    action()
                } label: {
                    Label(buttonTitle, systemImage: systemImageName)
                        .foregroundColor(Color("TextfieldBackgroundColor"))
                        .font(Font.custom("Poppins-Medium", size: 15))
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color("PlaceholderColor"))
                .cornerRadius(8)
            }
            .padding(.vertical, 15)
            
            Divider()
                .padding(.bottom, 25)
        }
    }
}
