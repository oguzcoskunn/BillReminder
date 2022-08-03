//
//  DoubleSwitchButtonview.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 28.07.2022.
//

import SwiftUI

struct DoubleSwitchButton: View {
    @Binding var selectedButton: Int
    let firstButtonText: Text
    let secondButtonText: Text
    let textSize: CGFloat
    let buttonHeight: CGFloat
    let viewWidth: CGFloat
    let viewHeight: CGFloat
    let radius: CGFloat
    let selectedButtonColor: Color
    let backgroundColor: Color
    
    var body: some View {
        ZStack() {
            backgroundColor
            
            HStack(spacing: 4) {
                Button {
                    self.selectedButton = 0
                } label: {
                    ZStack {
                        Color.clear
                        VStack {
                            self.firstButtonText
                                .foregroundColor(self.selectedButton == 0 ? Color.white : Color(#colorLiteral(red: 0.72, green: 0.72, blue: 0.72, alpha: 1)))
                                .font(.system(size: textSize, weight: .semibold))
                        }
                    }
                    .frame(height: buttonHeight)
                    .cornerRadius(radius)
                }
                .buttonStyle(FlatLinkStyle())
                
                Button {
                    self.selectedButton = 1
                } label: {
                    ZStack {
                        Color.clear
                        VStack {
                            self.secondButtonText
                                .foregroundColor(self.selectedButton == 1 ? Color.white : Color(#colorLiteral(red: 0.72, green: 0.72, blue: 0.72, alpha: 1)))
                                .font(.system(size: textSize, weight: .semibold))
                        }
                    }
                    .frame(height: buttonHeight)
                    .cornerRadius(radius)
                }
                .buttonStyle(FlatLinkStyle())
            }
            .background(
                GeometryReader { geo in
                    ZStack(alignment: self.selectedButton == 0 ? .leading : .trailing) {
                        Color.clear
                        
                        selectedButtonColor
                            .frame(width:  geo.size.width / 2)
                            .cornerRadius(radius)
                            .animation(.spring(), value: selectedButton)
                    }
                }
            )
            .padding(.horizontal, 2)
            
        }
        .frame(width: viewWidth, height: viewHeight)
        .cornerRadius(radius)
    }
}

