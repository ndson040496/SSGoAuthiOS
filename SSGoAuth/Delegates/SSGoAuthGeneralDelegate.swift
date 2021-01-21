//
//  SSGoAuthGeneralDelegate.swift
//  Okee
//
//  Created by Son Nguyen on 12/28/20.
//

import Foundation
import SwiftUI

public protocol SSGoAuthGeneralDelegate {
    func onLoginSuccess(user: SSGoAuthUser)
    func onLogout(completion: @escaping () -> Void)
}
