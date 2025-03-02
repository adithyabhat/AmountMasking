//
//  MaskingManager.swift
//  MaskingTest
//
//  Created by AdVar on 02/03/2025.
//

import SwiftUI
import Combine

// Make MaskingManager Sendable to satisfy concurrency requirements
class MaskingManager: ObservableObject, @unchecked Sendable {
    // Shared instance
    static let shared = MaskingManager()
    
    // Published property for masking state
    @Published var isMasked: Bool = false
    
    private init() {}
    
    var maskingPublisher: AnyPublisher<Bool, Never> {
        $isMasked.eraseToAnyPublisher()
    }
    
    // Simple toggle function
    func toggle() {
        DispatchQueue.main.async {
            self.isMasked.toggle()
        }
    }
}

// Protocol for financial masking
protocol FinancialMaskable {
    func maskedAmount(_ amount: String) -> String
}

// Default implementation
extension FinancialMaskable {
    // Get current masking state
    var isMasked: Bool {
        MaskingManager.shared.isMasked
    }
    
    func maskedAmount(_ amount: String) -> String {
        if isMasked {
            let components = amount.components(separatedBy: ".")
            if components.count == 2 {
                return "******.\(components[1])"
            }
            return "******.**"
        }
        return amount
    }
}

struct RefreshingMaskableView<Content: View>: View {
    @StateObject private var manager = MaskingManager.shared
    let content: (Bool) -> Content
    
    init(@ViewBuilder content: @escaping (Bool) -> Content) {
        self.content = content
    }
    
    var body: some View {
        // Pass the current masking state to the content builder
        content(manager.isMasked)
    }
}

