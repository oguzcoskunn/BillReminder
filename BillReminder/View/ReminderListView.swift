//
//  ReminderListView2.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 1.08.2022.
//

import SwiftUI

struct ReminderInfo {
    var billingName: String
    var paymentInformation: String
    var paymentFrequency: Int
    var paymentDay: Int
    var remindMeThisEarly: Int
    var selectedDate: Date
    var selectedDateString: String
    var reminderUid: String
}

struct RemindersListView: View {
    @EnvironmentObject var globalVeriables: GlobalVariables
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Reminder.timestamp, ascending: true)],
        animation: .default)
    private var reminders: FetchedResults<Reminder>
    @StateObject private var notificationManager = NotificationManager()
    @Binding var showSideBar: Bool
    @Binding var addNewReminder: Bool
    @State private var next7DaysCount: Int = 0
    @State private var next30DaysCount: Int = 0
    @State private var alreadyShowed: [String] = []
    @State private var showReminderDetail: Bool = false
    @State var currentReminderInfo = ReminderInfo(billingName: "none", paymentInformation: "none", paymentFrequency: 0, paymentDay: 1, remindMeThisEarly: 0, selectedDate: Date(), selectedDateString: "", reminderUid: "none")
    
    @ViewBuilder
    var infoOverlayView: some View {
        switch notificationManager.authorizationStatus {
        case .denied:
            InfoOverlayView(
                infoMessage: "Please Enable Notification Permission In Settings",
                buttonTitle: "Settings",
                systemImageName: "gear",
                action: {
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            )
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                TopMainBarView(showSideBar: self.$showSideBar)
                
                infoOverlayView
                    .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("In next 7 days")
                            .foregroundColor(Color("TextColor"))
                            .font(Font.custom("Poppins-Medium", size: 18))
                        
                       List {
                            ForEach(reminders) { reminder in
                                let dayDiff = getDayDiffFromNow(dateTo: reminder.timestamp!)
                                if dayDiff >= 0 && dayDiff < 7 && reminder.isActive {
                                    ReminderRowView(dayDiff: dayDiff, reminderTitle: reminder.title!, reminderInfo: reminder.info!, reminderDate: reminder.timestamp!)
                                        
                                        .onTapGesture {
                                            self.currentReminderInfo = ReminderInfo(billingName: reminder.title!, paymentInformation: reminder.info!, paymentFrequency: Int(reminder.frequency), paymentDay: Int(reminder.paymentDay), remindMeThisEarly: Int(reminder.reminMeThisEarly), selectedDate: reminder.selectedDate!, selectedDateString: reminder.selectedDateString!, reminderUid: reminder.reminderUid!)
                                            self.showReminderDetail = true
                                        }
                                        .swipeActions {
                                            Button {
                                                setAsPaid(reminder: reminder)
                                            } label: {
                                                Text("This is paid")
                                                    .font(Font.custom("Poppins-Medium", size: 14))
                                                    .foregroundColor(Color.black)
                                            }
                                            .tint(Color.green)
                                        }
                                        
//                                        .addSwipeAction {
//                                            Leading {}
//                                            Trailing {
//                                                Button {
//                                                    setAsPaid(reminder: reminder)
//                                                } label: {
//                                                    Text("This is paid")
//                                                        .padding(.leading, 10)
//                                                        .font(Font.custom("Poppins-Medium", size: 14))
//                                                        .foregroundColor(Color.black)
//                                                }
//                                                .frame(width: 130, height: 67, alignment: .center)
//                                                .contentShape(Rectangle())
//                                                .background(LinearGradient(
//                                                    gradient: Gradient(stops: [
//                                                .init(color: Color(#colorLiteral(red: 0.9115333557128906, green: 0.9333333373069763, blue: 0.27843135595321655, alpha: 1)), location: 0),
//                                                .init(color: Color(#colorLiteral(red: 0.49803921580314636, green: 0.8941176533699036, blue: 0.6235294342041016, alpha: 1)), location: 1),
//                                                .init(color: Color(#colorLiteral(red: 0.8583333492279053, green: 0.8583333492279053, blue: 0.8583333492279053, alpha: 0)), location: 1)]),
//                                                    startPoint: UnitPoint(x: -0.45161292583606094, y: 2.166666708059898),
//                                                    endPoint: UnitPoint(x: 1.9569892785121463, y: -0.5476190761567405)))
//                                                .cornerRadius(8, corners: [.topRight, .bottomRight])
//                                                .padding(.bottom, 8)
//                                            }
//                                        }
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
//                            .listRowInsets(EdgeInsets())
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                        }
                       
                       .listStyle(PlainListStyle())
                       .frame(height: CGFloat(self.next7DaysCount * 75))
                        .padding(.top, 10)
                       
                        Text("In next 30 days")
                            .foregroundColor(Color("TextColor"))
                            .font(Font.custom("Poppins-Medium", size: 18))
                            .padding(.top, 15)
                        
                        List {
                             ForEach(reminders) { reminder in
                                 let dayDiff = getDayDiffFromNow(dateTo: reminder.timestamp!)
                                 if dayDiff > 7 && dayDiff < 30 && reminder.isActive && !isAlreadyShowed(reminderUid: reminder.reminderUid!) && !isAlreadyShowed(reminderUid: reminder.uid!.uuidString) {
                                     ReminderRowView(dayDiff: dayDiff, reminderTitle: reminder.title!, reminderInfo: reminder.info!, reminderDate: reminder.timestamp!)
                                         .padding(.bottom, 8)
                                         .onTapGesture {
                                             self.currentReminderInfo = ReminderInfo(billingName: reminder.title!, paymentInformation: reminder.info!, paymentFrequency: Int(reminder.frequency), paymentDay: Int(reminder.paymentDay), remindMeThisEarly: Int(reminder.reminMeThisEarly), selectedDate: reminder.selectedDate!, selectedDateString: reminder.selectedDateString!, reminderUid: reminder.reminderUid!)
                                             self.showReminderDetail = true
                                         }
                                         .swipeActions {
                                             Button {
                                                 setAsPaid(reminder: reminder)
                                             } label: {
                                                 Text("This is paid")
                                                     .font(Font.custom("Poppins-Medium", size: 14))
                                                     .foregroundColor(Color.black)
                                             }
                                             .tint(Color.green)
                                         }
                                 }
                             }
                             .listRowBackground(Color.clear)
                             .listRowSeparator(.hidden)
                             .listRowInsets(EdgeInsets())
                         }
                        .listStyle(PlainListStyle())
                        .frame(height: CGFloat(self.next30DaysCount * 75))
                        .padding(.top, 10)
                    }
                    .padding(.bottom, globalVeriables.bottomSafeSpace + 10)
                    .padding(.horizontal, 16)
                    .onAppear {
                        self.next7DaysCount = getNext7DaysRemindersCount()
                        self.next30DaysCount = getNext30DaysRemindersCount()
                    }
                    .onChange(of: reminders.count) { _ in
                        self.next7DaysCount = getNext7DaysRemindersCount()
                        self.next30DaysCount = getNext30DaysRemindersCount()
                    }
                }
                .overlay(
                    ZStack {
                        Color.black
                        
                        VStack(alignment: .center, spacing: 12) {
                            Text("Seems you have no reminders yet")
                                .font(Font.custom("Poppins-Regular", size: 16))
                                .foregroundColor(Color("TextColor"))
                            
                            Button {
                                self.addNewReminder = true
                            } label: {
                                Text("Let’s create the first one!")
                                    .font(Font.custom("Poppins-Medium", size: 16))
                                    .overlay(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color(#colorLiteral(red: 0.9333333373069763, green: 0.8392156958580017, blue: 0.27843138575553894, alpha: 1)), location: 0),
                                                .init(color: Color(#colorLiteral(red: 0.49803921580314636, green: 0.8941176533699036, blue: 0.6235294342041016, alpha: 1)), location: 1)]),
                                            startPoint: UnitPoint(x: -0.45161292583606094, y: 2.166666708059898),
                                            endPoint: UnitPoint(x: 1.9569892785121463, y: -0.5476190761567405))
                                        .mask(Text("Let’s create the first one!")
                                            .underline()
                                            .font(Font.custom("Poppins-Medium", size: 16)))
                                    )
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 121)
                    }
                        .opacity(self.next7DaysCount == 0 && self.next30DaysCount == 0 ? 1 : 0)
                )
//                .onAppear(perform: {
//                    for reminder in reminders {
//                        setAsActive(reminder: reminder)
//                    }
//                })
                
                NavigationLink(isActive: self.$addNewReminder) {
                    AddReminderView(notificationManager: self.notificationManager)
                } label: {}
                
                NavigationLink(isActive: self.$showReminderDetail) {
                    ReminderDetailView(billingName: currentReminderInfo.billingName, paymentInformation: currentReminderInfo.paymentInformation, paymentFrequency: currentReminderInfo.paymentFrequency, paymentDay: currentReminderInfo.paymentDay, remindMeThisEarly: currentReminderInfo.remindMeThisEarly, selectedDate: currentReminderInfo.selectedDate, selectedDateString: currentReminderInfo.selectedDateString, reminderUid: currentReminderInfo.reminderUid, notificationManager: self.notificationManager, showReminderDetail: self.$showReminderDetail)
                } label: {}
                
            }
            .padding(.top, 8)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .background(Color.black)
        }
        .onAppear(perform: notificationManager.reloadAuthorizationStatus)
        .onChange(of: notificationManager.authorizationStatus) { authorizationStatus in
            switch authorizationStatus {
            case .notDetermined:
                notificationManager.requestAuthorization()
            case .authorized:
                notificationManager.reloadLocalNotifications()
            default:
                break
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            notificationManager.reloadAuthorizationStatus()
        }
    }
    
    private func getNext7DaysRemindersCount() -> Int {
        var count = 0
        self.alreadyShowed = []
        for reminder in reminders {
            let dayDiff = getDayDiffFromNow(dateTo: reminder.timestamp!)
            if dayDiff >= 0 && dayDiff < 7 && reminder.isActive {
                self.alreadyShowed.append(reminder.reminderUid!)
                count += 1
            }
        }
        return count
    }
    
    private func getNext30DaysRemindersCount() -> Int {
        var count = 0
        var showed: [String] = []
        for reminder in reminders {
            let dayDiff = getDayDiffFromNow(dateTo: reminder.timestamp!)
            if dayDiff > 7 && dayDiff < 30 && reminder.isActive && !isAlreadyShowed(reminderUid: reminder.reminderUid!) {
                var founded = false
                for showedUid in showed {
                    if showedUid == reminder.reminderUid! {
                        founded = true
                    }
                }
                if founded {
                    self.alreadyShowed.append(reminder.uid!.uuidString)
                } else {
                    count += 1
                }
                
                showed.append(reminder.reminderUid!)
            }
        }
        return count
    }
    
    private func isAlreadyShowed(reminderUid: String) -> Bool {
        var founded = false
        for showedReminderUid in self.alreadyShowed {
            if reminderUid == showedReminderUid {
                founded = true
            }
        }
        return founded
    }
    
    
    private func getDayDiffFromNow(dateTo: Date) -> Int {
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: Date.now)
        let dateTo = calendar.startOfDay(for: dateTo)
        let dateDiff = Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo)
        return Int(dateDiff.day!)
    }
    
    private func setAsActive(reminder: Reminder) {
        reminder.isActive = true
        self.next7DaysCount = getNext7DaysRemindersCount()
        self.next30DaysCount = getNext30DaysRemindersCount()
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func setAsPaid(reminder: Reminder) {
        withAnimation {
            reminder.isActive = false
            notificationManager.deleteLocalNotifications(
                identifiers: [reminder.notificationUid!]
            )
            
            self.next7DaysCount = getNext7DaysRemindersCount()
            self.next30DaysCount = getNext30DaysRemindersCount()
            
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

