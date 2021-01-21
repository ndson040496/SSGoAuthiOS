//
//  SSGoAuthLegalDelegate.swift
//  Okee
//
//  Created by Son Nguyen on 11/1/20.
//

import Foundation
import SwiftUI

public protocol SSGoAuthLegalDelegate {
    var termsAndConditionsView: AnyView { get }
    var privacyPolicyView: AnyView { get }
    var copyRightsText: String { get }
}
