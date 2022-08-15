//
//  ReminderDetailView.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 2.08.2022.
//

import SwiftUI

struct ReminderDetailView: View {
    let billingName: String
    let paymentInformation: String
    let paymentFrequency: Int
    let paymentDay: Int
    let remindMeThisEarly: Int
    let selectedDate: Date
    let selectedDateString: String
    let reminderUid: String
    @ObservedObject var notificationManager: NotificationManager
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    @Binding var showReminderDetail: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            TopBackBarView(titleText: Text("Reminder Details"))
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ReminderDetailRow(title: Text("Billing Name"), text: Text(billingName))
                    
                    ReminderDetailRow(title: Text("Payment Information"), text: Text(paymentInformation))
                    
                    ReminderDetailRow(title: Text("Payment Frequency"), text: paymentFrequency == 0 ? Text("Monthly") : Text("Weekly"))
                    
                    ReminderDetailRow(title: Text("Payment Day"), text: Text(selectedDateString))
                    
                    ReminderDetailRow(title: Text("Remind me this early"), text: Text(remindMeThisEarly > 0 ? remindMeThisEarly > 1 ? "\(remindMeThisEarly) days earlier" : "\(remindMeThisEarly) day earlier" : "Exactly the day"))
                    
                    NavigationLink {
                        LazyView(EditReminderView(notificationManager: notificationManager, reminderTitle: billingName, reminderInfo: paymentInformation, selectedFrequency: paymentFrequency, selectedDate: selectedDate, selectedDateString: selectedDateString, selectedDay: paymentDay, selectedDays: remindMeThisEarly, editReminderUid: reminderUid, showReminderDetail: self.$showReminderDetail))
                    } label: {
                        MainButtonView(buttonText: Text("Edit this reminder"))
                    }
                    .padding(.top, 12)
                }
                .padding(.horizontal, 16)
                .padding(.top, 27)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .background(Color.black)
        .onBackSwipe {
            self.showReminderDetail = false
        }
    }
}
