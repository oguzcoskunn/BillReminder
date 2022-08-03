//
//  TopBarView.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 1.08.2022.
//

import SwiftUI

struct TopMainBarView: View {
    @EnvironmentObject var globalVeriables: GlobalVariables
    @Binding var showSideBar: Bool
    
    var body: some View {
        HStack {
            Text("Bill reminder")
                .font(Font.custom("Poppins-Medium", size: 24))
                .overlay(
                    LinearGradient(
                                gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 0.9333333373069763, green: 0.8392156958580017, blue: 0.27843138575553894, alpha: 1)), location: 0),
                            .init(color: Color(#colorLiteral(red: 0.49803921580314636, green: 0.8941176533699036, blue: 0.6235294342041016, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: -0.45161292583606094, y: 2.166666708059898),
                                endPoint: UnitPoint(x: 1.9569892785121463, y: -0.5476190761567405))
                        .mask(Text("Bill reminder")
                            .font(Font.custom("Poppins-Medium", size: 24)))
                )
            
            Spacer()
            
            Button {
                self.showSideBar.toggle()
            } label: {
                Image("HamburgerMenuIcon")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, globalVeriables.topSafeSpace + 10)
        .padding(.bottom, 10)
        .background(Color.black)
    }
}

