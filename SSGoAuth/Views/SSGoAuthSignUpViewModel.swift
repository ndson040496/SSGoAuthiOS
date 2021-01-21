//
//  SSGoAuthSignUpViewModel.swift
//  Okee
//
//  Created by Son Nguyen on 11/30/20.
//

import Foundation
import SwiftUI
import Combine
import SSeoNetwork
import SSUI

class SSGoAuthSignUpViewModel: SSUIViewModel {
    
    @Published var createdUser: SSGoAuthUser? {
        didSet {
            self.didSetAPublishedProperty()
        }
    }
    
    func createAccount(email: String, name: String, password: String) {
        isLoading = true
        
        let request = SSGoAuthUserCreationRequest(usingEmail: email, name: name, password: password)
        let subcriber = SSNetworkManager.shared.makeServiceCall(forRequest: request)
            .sink(receiveCompletion: { [weak self] (completion) in
                SSNetworkManager.shared.unregisterSubscriber(forRequest: request)
                self?.isLoading = false

                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.setAlert(forError: error)
                }
            }, receiveValue: { [weak self] (user) in
                self?.setSuccessAlert(user: user)
            })
        SSNetworkManager.shared.registerSubscriber(forRequest: request, subscriber: subcriber)
    }
    
    func checkEntries(email: String, name: String, password: String, passwordAgain: String) -> Bool {
        let action = SSUIAlert.Action.text(SSGoAuthStrings.ok,
                                           config: SSGoAuth.shared.appearanceDelegate?.alertConfig.action)
        if password.isEmpty || passwordAgain.isEmpty || email.isEmpty || name.isEmpty {
            let title = SSUIAlert.Title(text: SSGoAuthStrings.signUpEmptyEntryTitle,
                                        config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title)
            let message = SSUIAlert.Message(text: SSGoAuthStrings.signUpEmptyEntryMessage,
                                            config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message)
            alert = SSUIAlert(isPresented: isAlertShownBinding, type: "",
                              title: title, message: message,
                              actions: [action], customView: SSGoAuth.shared.appearanceDelegate?.errorAlertTopView,
                              customViewPosition: .top)
            return false
        } else if password != passwordAgain || password.isEmpty || passwordAgain.isEmpty {
            let title = SSUIAlert.Title(text: SSGoAuthStrings.signUpPasswordMismatchTitle,
                                        config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title)
            let message = SSUIAlert.Message(text: SSGoAuthStrings.signUpPasswordMismatchMessage,
                                            config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message)
            alert = SSUIAlert(isPresented: isAlertShownBinding, type: "",
                              title: title, message: message,
                              actions: [action], customView: SSGoAuth.shared.appearanceDelegate?.errorAlertTopView,
                              customViewPosition: .top)
            return false
        } else {
            return true
        }
    }
    
    private func setSuccessAlert(user: SSGoAuthUser) {
        let title = SSUIAlert.Title(text: SSGoAuthStrings.signUpEmailSuccessTitle,
                                    config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title)
        let message = SSUIAlert.Message(text: SSGoAuthStrings.signUpEmailSuccessMessage,
                                        config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message)
        let action = SSUIAlert.Action.text(SSGoAuthStrings.ok,
                                           config: SSGoAuth.shared.appearanceDelegate?.alertConfig.action){
            self.createdUser = user
        }
        
        alert = SSUIAlert(isPresented: isAlertShownBinding, type: "",
                          title: title, message: message,
                          actions: [action], customView: SSGoAuth.shared.appearanceDelegate?.errorAlertTopView,
                          customViewPosition: .top)
    }
    
    private func setAlert(forError error: Error) {
        var customView: AnyView? = SSGoAuth.shared.appearanceDelegate?.errorAlertTopView
        let action = SSUIAlert.Action.text(SSGoAuthStrings.ok,
                                           config: SSGoAuth.shared.appearanceDelegate?.alertConfig.action)
        var title = SSGoAuthStrings.loginGenericErrorTitle
        var message = SSGoAuthStrings.loginGenericErrorMessage
        if error.isNoInternetError {
            title = SSGoAuthStrings.noInternetTitle
            message = SSGoAuthStrings.noInternetMessage
            customView = SSGoAuth.shared.appearanceDelegate?.noInternetErrorImage
        } else {
        
            if let error = error as? SSGoAuthNetworkError {
                let userCreationError = SSGoAuthUserCreationError.convertedError(forCode: error.customCode)
                switch userCreationError {
                case .invalidData:
                    title = SSGoAuthStrings.signUpInvalidDataTitle
                    message = SSGoAuthStrings.signUpInvalidDataMessage
                case .unknown, .localSetupError:
                    title = SSGoAuthStrings.signUpGenericErrorTitle
                    message = SSGoAuthStrings.signUpGenericErrorMessage
                case .userAlreadyExist:
                    title = SSGoAuthStrings.signUpUserAlreadyExistTitle
                    message = SSGoAuthStrings.signUpUserAlreadyExistMessage
                }
            }
        }
        let alertTitle = SSUIAlert.Title(text: title,
                                    config: SSGoAuth.shared.appearanceDelegate?.alertConfig.title)
        let alertMessage = SSUIAlert.Message(text: message,
                                        config: SSGoAuth.shared.appearanceDelegate?.alertConfig.message)
        alert = SSUIAlert(isPresented: isAlertShownBinding, type: "",
                          title: alertTitle, message: alertMessage,
                          actions: [action], customView: customView,
                          customViewPosition: .top)
    }
}
