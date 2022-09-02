//
//  View+Extension.swift
//  PasteVault
//
//  Created by Vishweshwaran on 22/07/22.
//

import SwiftUI

extension View {
    
    /// Adds the Navigation View with then help of modifier
    /// ```
    /// Text("Hello, world!")
    ///     .embedInNavigation()
    /// ```
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
    
    func embedInScrollView() -> some View {
        ScrollView { self }
    }
    
    /// Univeral modifier to hide a view from the view heirarchy
    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}
