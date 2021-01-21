//
//  SSGoAuthSignUpView.swift
//  Okee
//
//  Created by Son Nguyen on 11/1/20.
//

import SwiftUI
import SSUI

public struct SSGoAuthSignUpView<Content>: View where Content: View {
    
    @State private var email: String = ""
    @State private var name = ""
    @State private var password: String = ""
    @State private var passwordAgain: String = ""
    
    @State private var isTocPresented: Bool = false
    @State private var isPrivacyPolicyPresented: Bool = false
    
    private var isPresented: Binding<Bool>
    private var emailBinding: Binding<String>
    private let creator: (AnyView, Binding<Bool>) -> Content
    private let backgroundView: AnyView?
    
    @ObservedObject private var viewModel = SSGoAuthSignUpViewModel()
    
    public init(isPresented: Binding<Bool>, email: Binding<String>, backgroundView: AnyView?, @ViewBuilder creator: @escaping (AnyView, Binding<Bool>) -> Content) {
        self.isPresented = isPresented
        self.creator = creator
        self.emailBinding = email
        self.backgroundView = backgroundView
    }
    
    public var body: some View {
        isPresented.wrappedValue = viewModel.createdUser == nil
        if let email = viewModel.createdUser?.email {
            emailBinding.wrappedValue = email
        }
        let stack = VStack {
            inputFields
            legalView
            buttons.padding(.top, 40)
        }
        
        return SSUIKeyboardDismissView {
            creator(stack.anyView, isPresented)
        }
        .background(backgroundView ?? Color.clear.anyView)
        .loading(isPresented: viewModel.isLoadingBinding,
                 config: SSGoAuth.shared.appearanceDelegate?.loadingScreenConfig)
        .alert(isPresented: viewModel.isAlertShownBinding,
               configs: ["": SSGoAuth.shared.appearanceDelegate?.alertConfig.alert],
               alert: viewModel.alert)
    }
    
    private var inputFields: some View {
        let textFieldFormatter: (AnyView) -> AnyView = { view in
            return view
                .padding(.horizontal)
                .autocapitalization(.none)
                .anyView
        }
        let passwordRequirementTitle = SSUIAlert.Title(text: SSGoAuthStrings.info,
                                                       config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title)
        let passwordRequirementInfo = SSUIAlert.Message(text: SSGoAuthStrings.passwordRequirements,
                                                           config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message)
        let passwordRequirementAction = SSUIAlert.Action.text(SSGoAuthStrings.ok,
                                                              config: SSGoAuth.shared.appearanceDelegate?.alertConfig.action)
        
        return VStack {
            textFieldFormatter(SSUITextField(SSGoAuthStrings.email, text: $email)
                                .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textfieldConfig)
                                .keyboardType(.emailAddress)
                                .anyView)
            textFieldFormatter(SSUITextField(SSGoAuthStrings.name, text: $name)
                                .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textfieldConfig)
                                .anyView)
            textFieldFormatter(SSUISecureField(SSGoAuthStrings.password, text: $password, hasAdditionalInfo: true)
                                .addInfo(title: passwordRequirementTitle, info: passwordRequirementInfo,
                                         type: "", dismissButton: passwordRequirementAction,
                                         isInfoShown: viewModel.isAlertShownBinding, alert: viewModel.alertBinding)
                                .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textfieldConfig)
                                .anyView)
            textFieldFormatter(SSUISecureField(SSGoAuthStrings.passwordAgain, text: $passwordAgain, hasAdditionalInfo: true)
                                .addInfo(title: passwordRequirementTitle, info: passwordRequirementInfo,
                                         type: "", dismissButton: passwordRequirementAction,
                                         isInfoShown: viewModel.isAlertShownBinding, alert: viewModel.alertBinding)
                                .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textfieldConfig)
                                .anyView)
        }
    }
    
    private var legalView: some View {
        VStack {
            Text(SSGoAuthStrings.bySigningUp).font(.callout)
            HStack(spacing: 0) {
                Button(SSGoAuthStrings.toc) {
                    isTocPresented = true
                }.font(.callout).sheet(isPresented: $isTocPresented, content: {
                    SSGoAuth.shared.legalDelegate?.termsAndConditionsView
                })
                Text(" \(SSGoAuthStrings.and) ").font(.callout)
                Button(SSGoAuthStrings.privacyPolicy) {
                    isPrivacyPolicyPresented = true
                }.font(.callout).sheet(isPresented: $isPrivacyPolicyPresented, content: {
                    SSGoAuth.shared.legalDelegate?.privacyPolicyView
                })
            }
        }.padding(.top).padding(.horizontal)
    }
    
    private var buttons: some View {
        VStack {
            Button(SSGoAuthStrings.create) {
                guard viewModel.checkEntries(email: email, name: name,
                                             password: password, passwordAgain: passwordAgain) else {
                    return
                }
                viewModel.createAccount(email: email, name: name, password: password)
            }.frame(maxWidth: .infinity)
            .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.buttonConfig.primary)
            .padding(.horizontal)
        }.padding(.bottom)
    }
}
