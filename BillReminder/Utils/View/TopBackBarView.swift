//
//  TopBackBar.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 28.07.2022.
//

import SwiftUI

struct TopBackBarView: View {
    @EnvironmentObject var globalVeriables: GlobalVariables
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let titleText: Text
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center, spacing: 0) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("BackButton")
                        .renderingMode(.template)
                        .foregroundColor(Color("TextColor"))
                }
                Spacer()
            }
            
            self.titleText
                .foregroundColor(Color("TextColor"))
                .font(Font.custom("Poppins-Regular", size: 17))
        }
        .background(Color.black)
        .padding(.horizontal, 26)
        .padding(.top, globalVeriables.topSafeSpace + 17)
        .padding(.bottom, 10)
    }
}

