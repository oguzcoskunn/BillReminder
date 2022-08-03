//
//  MainButtonView.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 29.07.2022.
//

import SwiftUI

struct MainButtonView: View {
    let buttonText: Text
    
    var body: some View {
        //Frame 10
        ZStack {
            RoundedRectangle(cornerRadius: 6)
            .fill(Color(#colorLiteral(red: 0.8583333492279053, green: 0.8583333492279053, blue: 0.8583333492279053, alpha: 1)))

            RoundedRectangle(cornerRadius: 6)
            .fill(LinearGradient(
                    gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0.9333333373069763, green: 0.8392156958580017, blue: 0.27843138575553894, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 0.49803921580314636, green: 0.8941176533699036, blue: 0.6235294342041016, alpha: 1)), location: 1),
                .init(color: Color(#colorLiteral(red: 0.8583333492279053, green: 0.8583333492279053, blue: 0.8583333492279053, alpha: 0)), location: 1)]),
                    startPoint: UnitPoint(x: -0.45161292583606094, y: 2.166666708059898),
                    endPoint: UnitPoint(x: 1.9569892785121463, y: -0.5476190761567405)))
            
            self.buttonText
                .foregroundColor(.black)
                .font(Font.custom("Poppins-Medium", size: 16))
        }
        .frame(width: 186, height: 48)
    }
}

