//
//  SSGoAuthLoginView.swift
//  Okee
//
//  Created by Son Nguyen on 11/1/20.
//

import SwiftUI
import SSUI
import SSeoUtilities

public struct SSGoAuthLoginView<LoginContent, SignUpContent>: View where LoginContent: View, SignUpContent: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isSigningUp: Bool = false
    
    private let signUpViewCreator: (AnyView, Binding<Bool>) -> SignUpContent
    private let loginViewCreator: (AnyView) -> LoginContent
    private let signUpBackground: AnyView?
    @ObservedObject private var viewModel = SSGoAuthLoginViewModel()
    
    public init(@ViewBuilder loginViewCreator: @escaping (AnyView) -> LoginContent, @ViewBuilder signUpViewCreator: @escaping (AnyView, Binding<Bool>) -> SignUpContent, signUpBackground: AnyView? = nil) {
        self.signUpViewCreator = signUpViewCreator
        self.loginViewCreator = loginViewCreator
        self.signUpBackground = signUpBackground
    }
    
    public var body: some View {
        let textfieldFormatter: (AnyView) -> AnyView = { view in
            return view
                .padding(.horizontal)
                .autocapitalization(.none)
                .anyView
        }
        let stack = VStack {
            VStack {
                textfieldFormatter(SSUITextField(SSGoAuthStrings.email, text: $email)
                                    .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textfieldConfig)
                                    .keyboardType(.emailAddress)
                                    .anyView)
                textfieldFormatter(SSUISecureField(SSGoAuthStrings.password, text: $password)
                                    .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textfieldConfig)
                                    .anyView)
                HStack {
                    Spacer()
                    Button(SSGoAuthStrings.loginHelp) {
                        viewModel.resetPassword()
                    }.applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.buttonConfig.link)
                }
                
                Button {
                    SSUIKeyboardResponder.shared.hideKeyboard()
                    viewModel.login(withEmail: email, password: password)
                } label: {
                    Text(SSGoAuthStrings.login)
                        .frame(maxWidth: .infinity)
                        .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.buttonConfig.primary)
                }.padding(.horizontal)

                if #available(iOS 14, *) {
                    Button(SSGoAuthStrings.signUp) {
                        isSigningUp = true
                    }.applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.buttonConfig.link)
                    .fullScreenCover(isPresented: $isSigningUp) {
                        SSGoAuthSignUpView(isPresented: $isSigningUp, email: $email, backgroundView: signUpBackground, creator: signUpViewCreator)
                    }
                } else {
                    Button(SSGoAuthStrings.signUp) {
                        isSigningUp = true
                    }.applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.buttonConfig.link)
                    .sheet(isPresented: $isSigningUp) {
                        SSGoAuthSignUpView(isPresented: $isSigningUp, email: $email, backgroundView: signUpBackground, creator: signUpViewCreator)
                    }
                }
            }
        }.anyView
        
        return SSUIKeyboardDismissView {
            loginViewCreator(stack)
                .form(isPresented: viewModel.isFormShownBinding,
                      configs: ["": SSGoAuth.shared.appearanceDelegate?.formConfig],
                      form: viewModel.form)
                .alert(isPresented: viewModel.isAlertShownBinding,
                       configs: ["": SSGoAuth.shared.appearanceDelegate?.alertConfig.alert],
                       alert: viewModel.alert)
                .loading(isPresented: viewModel.isLoadingBinding, config: SSGoAuth.shared.appearanceDelegate?.loadingScreenConfig)
        }
    }
}
