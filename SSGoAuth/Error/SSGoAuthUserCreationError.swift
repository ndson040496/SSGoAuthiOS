//
//  SSGoAuthUserCreationError.swift
//  Okee
//
//  Created by Son Nguyen on 11/30/20.
//

import Foundation

enum SSGoAuthUserCreationError: Error {
    case unknown
    case localSetupError
    case invalidData
    case userAlreadyExist
    
    static func convertedError(forCode code: Int) -> SSGoAuthUserCreationError {
        switch code {
        case 1001:
            return SSGoAuthUserCreationError.invalidData
        case 1002:
            return SSGoAuthUserCreationError.localSetupError
        case 1003:
            return SSGoAuthUserCreationError.userAlreadyExist
        default:
            return SSGoAuthUserCreationError.unknown
        }
    }
}
