//
//  SideBarStack.swift
//  BillReminder
//
//  Created by Oğuz Coşkun on 1.08.2022.
//

import SwiftUI


struct SideBarStackView<SidebarContent: View, Content: View>: View {
    let sidebarContent: SidebarContent
    let mainContent: Content
    let sidebarWidth: CGFloat
    @Binding var showSidebar: Bool
    
    init(sidebarWidth: CGFloat, showSidebar: Binding<Bool>, @ViewBuilder sidebar: ()->SidebarContent, @ViewBuilder content: ()->Content) {
        self.sidebarWidth = sidebarWidth
        self._showSidebar = showSidebar
        sidebarContent = sidebar()
        mainContent = content()
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            mainContent
                .overlay(
                    Color.black
                        .opacity(showSidebar ? 0.5 : 0)
                        .onTapGesture {
                            self.showSidebar = false
                        }
                )
//                .offset(x: showSidebar ? sidebarWidth : 0, y: 0)
                .animation(Animation.easeInOut.speed(2), value: showSidebar)
            
            sidebarContent
                .frame(width: sidebarWidth, alignment: .center)
                .offset(x: showSidebar ? 0 : 1 * sidebarWidth, y: 0)
                .animation(Animation.easeInOut.speed(2), value: showSidebar)
            
                
        }
        .edgesIgnoringSafeArea(.all)
    }
}
