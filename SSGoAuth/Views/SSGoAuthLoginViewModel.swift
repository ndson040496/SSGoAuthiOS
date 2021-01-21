//
//  SSGoAuthLoginViewModel.swift
//  Okee
//
//  Created by Son Nguyen on 12/5/20.
//

import Foundation
import SwiftUI
import SSUI

class SSGoAuthLoginViewModel: SSUIViewModel {
    
    private var emailToResetPassword: String = ""
    
    func login(withEmail email: String, password: String) {
        isLoading = true
        SSGoAuth.shared.login(withEmail: email, password: password) { [weak self] (isSuccessful, error) in
            self?.isLoading = false
            if let error = error {
                self?.setLoginAlert(forError: error)
            }
        }
    }
    
    func resetPassword() {
        form = SSUIForm(type: "") {[weak self] in
            guard let strongSelf = self else {
                return EmptyView().anyView
            }
            return VStack {
                Text(SSGoAuthStrings.resetPassword)
                    .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textConfig.title)
                    .padding(.horizontal)
                    .padding(.top, SSGoAuth.shared.appearanceDelegate?.formConfig.contentPosition == .top
                                ? SSUI.safeAreaTopInset
                                : 0)
                Text(SSGoAuthStrings.resetPasswordExplanation)
                    .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textConfig.body)
                    .multilineTextAlignment(.center).padding(.horizontal)
                TextField(SSGoAuthStrings.email, text: Binding<String>(get: { () -> String in
                    return strongSelf.emailToResetPassword
                }, set: { (value) in
                    strongSelf.emailToResetPassword = value
                }))
                .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.textfieldConfig)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                
                Button(SSGoAuthStrings.sendRequest) {
                    strongSelf.isFormShownBinding.wrappedValue = false
                    guard let email = self?.emailToResetPassword else {
                        return
                    }
                    self?.isLoading = true
                    SSGoAuth.shared.sendResetPassword(toEmail: email) { (isSuccessful) in
                        self?.isLoading = false
                        self?.setResetPasswordAlert(isSuccessful: isSuccessful)
                    }
                }
                .frame(maxWidth: .infinity)
                .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.buttonConfig.primary)
                .padding(.top)
                Button(SSGoAuthStrings.cancel) {
                    strongSelf.isFormShownBinding.wrappedValue = false
                }
                .frame(maxWidth: .infinity)
                .applySSUIConfig(SSGoAuth.shared.appearanceDelegate?.buttonConfig.dismissive)
                .padding(.bottom, SSGoAuth.shared.appearanceDelegate?.formConfig.contentPosition == .bottom
                            ? SSUI.safeAreaBottomInset
                            : 0)
            }.padding().anyView
        }
    }
    
    private func setResetPasswordAlert(isSuccessful: Bool) {
        if isSuccessful {
            let title = SSUIAlert.Title(text: SSGoAuthStrings.resetPasswordEmailSentTitle,
                                        config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title)
            let message = SSUIAlert.Message(text: SSGoAuthStrings.resetPasswordEmailSentMessage,
                                            config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message)
            let action = SSUIAlert.Action.text(SSGoAuthStrings.ok,
                                               config: SSGoAuth.shared.appearanceDelegate?.alertConfig.action) { [weak self] in
                self?.isAlertShownBinding.wrappedValue = false
            }
            alert = SSUIAlert(isPresented: self.isAlertShownBinding, type: "", title: title, message: message, actions: [action])
        } else {
            let title = SSUIAlert.Title(text: SSGoAuthStrings.resetPasswordErrorTitle,
                                        config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title)
            let message = SSUIAlert.Message(text: SSGoAuthStrings.resetPasswordErrorMessage,
                                            config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message)
            let action = SSUIAlert.Action.text(SSGoAuthStrings.ok,
                                               config: SSGoAuth.shared.appearanceDelegate?.alertConfig.action) { [weak self] in
                self?.isAlertShownBinding.wrappedValue = false
            }
            alert = SSUIAlert(isPresented: self.isAlertShownBinding, type: "", title: title, message: message, actions: [action])
        }
    }
    
    private func setLoginAlert(forError error: SSGoAuthLoginError) {
        var customView: AnyView? = SSGoAuth.shared.appearanceDelegate?.errorAlertTopView
        let action = SSUIAlert.Action.text(SSGoAuthStrings.ok,
                                           config: SSGoAuth.shared.appearanceDelegate?.alertConfig.action) {[weak self] in
            self?.isAlertShownBinding.wrappedValue = false
        }
        var title = SSGoAuthStrings.loginGenericErrorTitle
        var message = SSGoAuthStrings.loginGenericErrorMessage
        switch error {
        case .unknown:
            title = SSGoAuthStrings.loginGenericErrorTitle
            message = SSGoAuthStrings.loginGenericErrorMessage
        case .invalidCredential:
            title = SSGoAuthStrings.loginInvalidCredentialTitle
            message = SSGoAuthStrings.loginInvalidCredentialMessage
        case .userDisabled:
            title = SSGoAuthStrings.loginUserDisabledTitle
            message = SSGoAuthStrings.loginUserDisabledMessage
        case .userNotFound:
            title = SSGoAuthStrings.loginUserNotFoundTitle
            message = SSGoAuthStrings.loginUserNotFoundMessage
        case .accountConflicted:
            title = SSGoAuthStrings.loginAccountConflictedTitle
            message = SSGoAuthStrings.loginAccountConflictedMessage
        case .networkError:
            title = SSGoAuthStrings.loginNetworkErrorTitle
            message = SSGoAuthStrings.loginNetworkErrorMessage
        case .noInternetError:
            title = SSGoAuthStrings.noInternetTitle
            message = SSGoAuthStrings.noInternetMessage
            customView = SSGoAuth.shared.appearanceDelegate?.noInternetErrorImage
        case .tokenExpired:
            title = SSGoAuthStrings.loginTokenExpiredTitle
            message = SSGoAuthStrings.loginTokenExpiredMessage
        }
        self.alert = SSUIAlert(isPresented: self.isAlertShownBinding, type: "",
                               title: SSUIAlert.Title(text: title, config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title),
                               message: SSUIAlert.Message(text: message, config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message),
                               actions: [action], customView: customView, customViewPosition: .top)
    }
}
