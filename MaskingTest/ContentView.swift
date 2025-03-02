//
//  ContentView.swift
//  MaskingTest
//
//  Created by AdVar on 02/03/2025.
//

import SwiftUI

struct ContentView: View, FinancialMaskable {
    let balance: String
    
    var body: some View {
        RefreshingMaskableView { _ in
            VStack(alignment: .leading) {
                MaskingToggle()
                    .frame(height: 40)
                Text("Current Balance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(maskedAmount(balance))
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
    }
    
}

#Preview {
    ContentView(balance: "34635.0")
}

struct MaskingToggle: View {
    @ObservedObject private var manager = MaskingManager.shared
    
    var body: some View {
        Button(action: {
            manager.toggle()
        }) {
            Image(systemName: manager.isMasked ? "eye.slash.fill" : "eye.fill")
        }
    }
}
