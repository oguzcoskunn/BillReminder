//
//  ContentView.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 28.07.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var globalVeriables: GlobalVariables
    @State private var showSideBar: Bool = false
    @State private var addNewReminder: Bool = false
    
    var body: some View {
        SideBarStackView(sidebarWidth: 222, showSidebar: $showSideBar) {
            HamburgerMenuView(showSideBar: self.$showSideBar, addNewReminder: self.$addNewReminder)
        } content: {
            RemindersListView(showSideBar: self.$showSideBar, addNewReminder: self.$addNewReminder)
        }
        .overlay(
            GeometryReader { geo in
                Color.clear.onAppear {
                    globalVeriables.topSafeSpace = geo.safeAreaInsets.top
                    globalVeriables.bottomSafeSpace = geo.safeAreaInsets.bottom
                }
            }
        )
    }
}


