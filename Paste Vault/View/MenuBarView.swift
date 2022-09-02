//
//  MenuBarView.swift
//  PasteVault
//
//  Created by Vishweshwaran on 22/07/22.
//

import SwiftUI
import FontKit

struct MenuBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "paperclip")
                .font(.headline)
                .rotationEffect(.init(degrees: -45))
        }
        .padding(.horizontal, 4)
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
    }
}
