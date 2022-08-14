//
//  HamburgerMenuView.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 1.08.2022.
//

import SwiftUI
import MessageUI

struct HamburgerMenuView: View {
    @Binding var showSideBar: Bool
    @Binding var addNewReminder: Bool
    @Binding var isShowingMailView: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("HamburgerMenuBackgroundColor")
            VStack(alignment: .leading, spacing: 0) {
                Image("HamburgerMenuIcon")
                
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        self.showSideBar = false
                        self.addNewReminder = true
                    } label: {
                        HStack(spacing: 10) {
                            Image("PlusIcon")
                            
                            Text("Create Reminder")
                        }
                    }

                    
                    Divider()
                    
                    Button {
                        if MFMailComposeViewController.canSendMail() {
                            self.showSideBar = false
                            self.isShowingMailView = true
                        } else {
                            print("You cant send mail from this device")
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image("QuestionmarkIcon")
                            
                            Text("Contact Us")
                        }
                    }
                    
                    Divider()
                    
                    Button {
                        if MFMailComposeViewController.canSendMail() {
                            self.showSideBar = false
                            self.isShowingMailView = true
                        } else {
                            print("You cant send mail from this device")
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image("MailIcon")
                            
                            Text("Suggest us anything")
                        }
                    }
                }
                .foregroundColor(Color("TextColor"))
                .font(Font.custom("Poppins-Medium", size: 14))
                .padding(.top, 29)
            }
            .padding(.top, 57)
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}
