//
//  AppearanceDelegate.swift
//  Okee
//
//  Created by Son Nguyen on 1/3/21.
//

import Foundation
import SwiftUI
import SSUI

public protocol SSGoAuthAppearanceDelegate {
    var buttonConfig: (primary: SSUIViewConfig, dismissive: SSUIViewConfig, link: SSUIViewConfig) { get }
    var textConfig: (title: SSUIViewConfig, body: SSUIViewConfig) { get }
    var textfieldConfig: SSUIViewConfig { get }
    var alertConfig: (alert: SSUIAlertConfig, title: SSUIViewConfig, message: SSUIViewConfig, action: SSUIViewConfig) { get }
    var loadingScreenConfig: SSUILoadingScreenConfig { get }
    var formConfig: SSUIFormConfig { get }
    var noInternetErrorImage: AnyView? { get }
    var errorAlertTopView: AnyView? { get }
    var successAlertTopView: AnyView? { get }
}
