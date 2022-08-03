//
//  BillReminderApp.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 28.07.2022.
//

import SwiftUI

@main
struct BillReminderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(GlobalVariables())
        }
    }
}
