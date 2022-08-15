//
//  AddReminderView.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 28.07.2022.
//

import SwiftUI

struct AddReminderView: View {
    @EnvironmentObject var globalVeriables: GlobalVariables
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var keyboardHandler = KeyboardHandler()
    @ObservedObject var notificationManager: NotificationManager
    @State private var reminderTitle: String = ""
    @State private var reminderInfo: String = ""
    @State private var selectedFrequency: Int = 0
    @State private var showDatePicker: Bool = false
    @State private var selectedDate = Date()
    @State private var selectedDateString: String = ""
    @State private var selectedDay: Int = Date.now.dayNumberOfWeek()!
    @State private var showDaysPicker: Bool = false
    @State private var selectedDays: Int = 0
    @State private var dontChange: Bool = false
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        VStack(spacing: 0) {
            TopBackBarView(titleText: Text("Create Reminder"))
            
            ScrollView {
                ZStack {
                    Color.black
                        .onTapGesture {
                            hideKeyboard()
                        }
                    
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 24) {
                            TextFieldRow(title: Text("Billing Name"), placeholder: Text("Billing Name"), text: self.$reminderTitle)
                            
                            TextFieldRow(
                                title: Text("Payment Information") +
                                Text(" (optional)")
                                    .font(Font.custom("Poppins-Medium", size: 14))
                                    .foregroundColor(Color("PlaceholderColor"))
                                , placeholder: Text("Payment Information"), text: self.$reminderInfo)
                            
                            HStack {
                                Text("Payment Frequency")
                                    .font(Font.custom("Poppins-Medium", size: 14))
                                    .foregroundColor(Color("TextColor"))
                                Spacer()
                                DoubleSwitchButton(selectedButton: self.$selectedFrequency, firstButtonText: Text("Monthly"), secondButtonText: Text("Weekly"), textSize: 13, buttonHeight: 28, viewWidth: 180, viewHeight: 32, radius: 6.93, selectedButtonColor: Color("SelectedButtonColor"), backgroundColor: Color("TextfieldBackgroundColor"))
                            }
                            
                            VStack(spacing: 10) {
                                Button {
                                    hideKeyboard()
                                    withAnimation(.spring()) {
                                        self.showDatePicker.toggle()
                                    }
                                    
                                } label: {
                                    HStack {
                                        Text("Next Payment Day")
                                            .font(Font.custom("Poppins-Medium", size: 14))
                                            .foregroundColor(Color("TextColor"))
                                        Spacer()
                                        if selectedDateString.isEmpty {
                                            Image("CalendarIcon")
                                        } else {
                                            HStack(spacing: 12) {
                                                //                                            Text(self.selectedFrequency == 0 ? selectedDateString(selectedDate: self.selectedDate) : days[self.selectedDay-1])
                                                Text(self.selectedDateString)
                                                    .font(Font.custom("Poppins-Regular", size: 14))
                                                    .foregroundColor(Color("TextColor"))
                                                
                                                Image("RightArrowIcon")
                                            }
                                        }
                                    }
                                }
                                
                                
                                if self.showDatePicker {
                                    if self.selectedFrequency == 0 {
                                        DatePicker("", selection: self.$selectedDate, in: Date()..., displayedComponents: .date)
                                            .colorScheme(.dark)
                                            .datePickerStyle(GraphicalDatePickerStyle())
                                            .labelsHidden()
                                            .padding(.horizontal, 16)
                                            .background(Color("TextfieldBackgroundColor"))
                                            .cornerRadius(8)
                                    } else {
                                        Picker("", selection: $selectedDay) {
                                            ForEach((1...6), id: \.self) {
                                                Text(days[$0])
                                                    .tag($0 + 1)
                                            }
                                            Text("Sunday")
                                                .tag(1)
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .colorScheme(.dark)
                                        .background(Color("TextfieldBackgroundColor"))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            
                            VStack(spacing: 10) {
                                Button {
                                    hideKeyboard()
                                    withAnimation(.spring()) {
                                        self.showDaysPicker.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Text("Remind me this early")
                                            .font(Font.custom("Poppins-Medium", size: 14))
                                            .foregroundColor(Color("TextColor"))
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 12) {
                                            Text(self.selectedDays > 0 ? self.selectedDays > 1 ? "\(self.selectedDays) days earlier" : "\(self.selectedDays) day earlier" : "Exactly the day")
                                                .font(Font.custom("Poppins-Regular", size: 14))
                                                .foregroundColor(Color("TextColor"))
                                            
                                            Image("RightArrowIcon")
                                        }
                                    }
                                }
                                
                                if self.showDaysPicker {
                                    Picker("", selection: $selectedDays) {
                                        Text("Exactly the day")
                                            .tag(0)
                                        
                                        ForEach(self.selectedFrequency == 0 ? (1...30) : (1...7), id: \.self) {
                                            Text("\($0) ") + Text($0 > 1 ? "days earlier" : "day earlier")
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .colorScheme(.dark)
                                    .background(Color("TextfieldBackgroundColor"))
                                    .cornerRadius(8)
                                }
                                
                            }
                        }
                        .padding(.horizontal, 26)
                        
                        Button {
                            if self.selectedFrequency == 0 {
                                addReminderMonthly(billingName: self.reminderTitle, billingInfo: self.reminderInfo, paymentFrequency: self.selectedFrequency, reminderDate: self.selectedDate, remindMeThisEarly: self.selectedDays)
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                addReminderWeekly(billingName: self.reminderTitle, billingInfo: self.reminderInfo, paymentFrequency: self.selectedFrequency, reminderDay: self.selectedDay, remindMeThisEarly: self.selectedDays)
                            }
                            
                        } label: {
                            MainButtonView(buttonText: Text("Create Reminder"))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, globalVeriables.bottomSafeSpace + 10)
                    }
                    .padding(.top, 28)
                    .onChange(of: self.selectedDate.description, perform: { newValue in
                        if !self.dontChange {
                            self.selectedDateString = selectedDateString(reminderDate: self.selectedDate)
                        } else {
                            self.dontChange = false
                        }
                    })
                    .onChange(of: self.selectedDay, perform: { newValue in
                        if !self.dontChange {
                            self.selectedDateString = days[newValue-1]
                            
                        } else {
                            self.dontChange = false
                        }
                    })
                    .onChange(of: self.selectedFrequency) { newValue in
                        if newValue == 0 {
                            if self.selectedDate.description != Date().description {
                                self.dontChange = true
                                self.selectedDate = Date()
                            }
                            
                        } else {
                            if self.selectedDay != Date().dayNumberOfWeek()! {
                                self.dontChange = true
                                self.selectedDay = Date().dayNumberOfWeek()!
                            }
                        }
                        self.showDaysPicker = false
                        self.showDatePicker = false
                        self.selectedDays = 0
                        self.selectedDateString = ""
                    }
                }
            }
        }
        .padding(.bottom, self.keyboardHandler.keyboardHeight)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .background(Color.black)
        .onBackSwipe {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func selectedDateString(reminderDate: Date) -> String {
        if let dayInt = Int(self.selectedDate.formatted(as: "dd")) {
            var dayString: String = ""
            if dayInt == 1 {
                dayString = "\(dayInt)st"
            } else if dayInt == 2 {
                dayString = "\(dayInt)nd"
            } else if dayInt == 3 {
                dayString = "\(dayInt)rd"
            } else {
                dayString = "\(dayInt)th"
            }
            let string = "\(dayString) of every month"
            return string
        } else {
            return ""
        }
    }
    
    private func addReminderWeekly(billingName: String, billingInfo: String, paymentFrequency: Int, reminderDay: Int, remindMeThisEarly: Int) {
        var lastReminderDay = reminderDay
        lastReminderDay -= remindMeThisEarly
        if lastReminderDay < 1 {
            lastReminderDay += 7
        }
        var specifyDateComponents = DateComponents()
        specifyDateComponents.year = Int(Date.now.formatted(as: "yyyy"))
        specifyDateComponents.timeZone = TimeZone.current
        specifyDateComponents.hour = 7
        specifyDateComponents.minute = 0
        specifyDateComponents.month = 1
        
        var reminderDateComponents = DateComponents()
        reminderDateComponents.calendar = Calendar.current
        reminderDateComponents.hour = 7
        reminderDateComponents.minute = 0
        
        let userCalendar = Calendar.current
        var someDateTime = userCalendar.date(from: specifyDateComponents)
        var add1Day = DateComponents()
        add1Day.day = 1
        while someDateTime!.dayNumberOfWeek()! != lastReminderDay {
            someDateTime = Calendar.current.date(byAdding: add1Day, to: someDateTime!)!
        }
        let nextYear: Int = Int(someDateTime!.formatted(as: "yyyy"))! + 1
        var add7Day = DateComponents()
        add7Day.day = 7
        let reminderUid = UUID().uuidString
        while Int(someDateTime!.formatted(as: "yyyy"))! < nextYear {
            reminderDateComponents.day = Int(someDateTime!.formatted(as: "dd"))
            reminderDateComponents.month = Int(someDateTime!.formatted(as: "MM"))
            createWeeklyReminderforYear(reminderUid: reminderUid, billingName: billingName, billingInfo: billingInfo, reminderDateComponents: reminderDateComponents, speicfyDate: someDateTime!)
            someDateTime = Calendar.current.date(byAdding: add7Day, to: someDateTime!)!
        }

        if Int(someDateTime!.formatted(as: "yyyy"))! == nextYear {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func createWeeklyReminderforYear(reminderUid: String ,billingName: String, billingInfo: String, reminderDateComponents: DateComponents, speicfyDate: Date) {
        let notificationUid = UUID().uuidString
        notificationManager.createLocalNotification(uid: notificationUid, title: billingName, info: billingInfo, dateComponents: reminderDateComponents) { error in
            if error == nil {
                let newReminder = Reminder(context: viewContext)
                newReminder.notificationUid = notificationUid
                newReminder.title = billingName
                newReminder.info = billingInfo
                newReminder.reminderUid = reminderUid
                newReminder.isActive = true
                newReminder.timestamp = speicfyDate
                newReminder.frequency = Int16(self.selectedFrequency)
                newReminder.paymentDay = Int16(self.selectedDay)
                newReminder.reminMeThisEarly = Int16(self.selectedDays)
                newReminder.selectedDateString = self.selectedDateString
                newReminder.selectedDate = self.selectedDate
                newReminder.uid = UUID()
                
                
                DispatchQueue.main.async {
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
    }
    
    private func addReminderMonthly(billingName: String, billingInfo: String, paymentFrequency: Int, reminderDate: Date, remindMeThisEarly: Int) {
        var dayComponent = DateComponents()
        dayComponent.day = -remindMeThisEarly
        
        let lastDate =  Calendar.current.date(byAdding: dayComponent, to: reminderDate)!
        
        var reminderDateComponents = DateComponents()
        reminderDateComponents.calendar = Calendar.current
        reminderDateComponents.hour = 7
        reminderDateComponents.minute = 0
        
        
        let userCalendar = Calendar.current
        let reminderUid = UUID().uuidString
        for month in 1...12 {
            reminderDateComponents.month = month
            
            var specifyDateComponents = DateComponents()
            specifyDateComponents.year = Int(lastDate.formatted(as: "yyyy"))
            specifyDateComponents.timeZone = TimeZone.current
            specifyDateComponents.hour = 7
            specifyDateComponents.minute = 0
            specifyDateComponents.month = month
            var someDateTime = userCalendar.date(from: specifyDateComponents)
            if Int(someDateTime!.endOfMonth().formatted(as: "dd"))! < Int(lastDate.formatted(as: "dd"))! {
                reminderDateComponents.day = Int(someDateTime!.endOfMonth().formatted(as: "dd"))
                specifyDateComponents.day = Int(someDateTime!.endOfMonth().formatted(as: "dd"))
            } else {
                reminderDateComponents.day = Int(lastDate.formatted(as: "dd"))
                specifyDateComponents.day = Int(lastDate.formatted(as: "dd"))
            }
            someDateTime = userCalendar.date(from: specifyDateComponents)
            createMonthlyReminderforYear(reminderUid: reminderUid, billingName: billingName, billingInfo: billingInfo, reminderDateComponents: reminderDateComponents, speicfyDate: someDateTime!)
        }
    }
    
    private func createMonthlyReminderforYear(reminderUid: String ,billingName: String, billingInfo: String, reminderDateComponents: DateComponents, speicfyDate: Date) {
        let notificationUid = UUID().uuidString
        notificationManager.createLocalNotification(uid: notificationUid, title: billingName, info: billingInfo, dateComponents: reminderDateComponents) { error in
            if error == nil {
                let newReminder = Reminder(context: viewContext)
                newReminder.notificationUid = notificationUid
                newReminder.title = billingName
                newReminder.info = billingInfo
                newReminder.reminderUid = reminderUid
                newReminder.isActive = true
                newReminder.timestamp = speicfyDate
                newReminder.frequency = Int16(self.selectedFrequency)
                newReminder.paymentDay = Int16(self.selectedDay)
                newReminder.reminMeThisEarly = Int16(self.selectedDays)
                newReminder.selectedDateString = self.selectedDateString
                newReminder.selectedDate = self.selectedDate
                newReminder.uid = UUID()
                
                DispatchQueue.main.async {
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
    }
}



