//
//  SSGoAuthFooterView.swift
//  Okee
//
//  Created by Son Nguyen on 11/1/20.
//

import SwiftUI
import SSUI

struct SSGoAuthFooterView: View {
    
    @State private var isToCPresented: Bool = false
    @State private var isPrivacyPolicyPresented: Bool = false
    
    var body: some View {
        let formatter: (AnyView) -> AnyView = { view in
            return view.font(.caption)
                .foregroundColor(.black)
                .opacity(0.5)
                .anyView
        }
        VStack {
            HStack {
                formatter(Button(SSGoAuthStrings.toc) {
                    isToCPresented = true
                }.anyView).sheet(isPresented: $isToCPresented, content: {
                    SSGoAuth.shared.legalDelegate?.termsAndConditionsView
                })
                formatter(Text("|").anyView)
                formatter(Button(SSGoAuthStrings.privacyPolicy) {
                    isPrivacyPolicyPresented = true
                }.anyView).sheet(isPresented: $isPrivacyPolicyPresented, content: {
                    SSGoAuth.shared.legalDelegate?.privacyPolicyView
                })
            }
            Text(SSGoAuth.shared.legalDelegate?.copyRightsText ?? "")
                .font(Font.system(size: 8))
                .foregroundColor(.gray)
                .padding(.vertical, 2)
        }
    }
}
