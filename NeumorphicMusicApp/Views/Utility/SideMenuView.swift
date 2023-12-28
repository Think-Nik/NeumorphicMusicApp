//
//  SideMenuView.swift
//  NeumorphicMusicApp
//
//  Created by Nikhil Thaware on 20/12/23.
//

import SwiftUI

struct SideMenuView: View {
    
    @Binding var selectedSideMenuTab: Int
    @Binding var isShowing: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NeumorphicShape(shape: Circle())
                    .overlay(content: {
                        Image("e31f2b29fc82e2b82898397e93f45c4a", bundle: nil)
                            .resizable()
                            .foregroundStyle(Color.gray)
                            .clipShape(Circle())
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    })
                    .frame(width: geometry.size.width * 0.6)
                    .padding(40)
                
                VStack {
                    ForEach(SideMenus.allCases, id: \.self) { row in
                        rowView(title: row.title,
                                icon: row.icon,
                                isSelected: selectedSideMenuTab == row.rawValue) {
                            selectedSideMenuTab = row.rawValue
                            isShowing.toggle()
                        }
                                .padding(-10)
                    }
                }
            }
            .padding(.leading, 100)
            .frame(width: geometry.size.width * 0.6)
        }
    }
    
    private func rowView(title: String, icon: String, isSelected: Bool, action: (@escaping() -> Void)) -> some View {
        let view = HStack {
            Image(systemName: icon)
            Text(title)
                .bold()
            Spacer()
        }
            .foregroundStyle(Color("ContentColor"))
        return NeumorphicButtonView(shape: RoundedRectangle(cornerRadius: 10),
                                    view: view,
                                    isHighlited: .constant(isSelected),
                                    padding: 20) {
            action()
        }
                                    .frame(width: 200, height: 100)
    }
}

struct SideMenu: View {
    
    @Binding var isShowing: Bool
    @Binding var selectedSideMenuTab: Int
    var edgeTransition: AnyTransition = .move(edge: .trailing)
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                SideMenuView(selectedSideMenuTab: $selectedSideMenuTab,
                             isShowing: $isShowing)
                .transition(edgeTransition)
                .background(
                    Color("BackgorundColor")
                )
                .padding(.top, 40)
                .frame(width: 250)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}
