//
//  SSGoAuthUserCreationDelegate.swift
//  Okee
//
//  Created by Son Nguyen on 11/30/20.
//

import Foundation
import SwiftUI
import SSeoNetwork

public protocol SSGoAuthUserCreationDelegate {
    var authServiceUrl: String { get }
    var path: [String]? { get }
    
    func setAuthentication(request: SSNetworkRequest<SSGoAuthUser, SSGoAuthNetworkError>)
}
