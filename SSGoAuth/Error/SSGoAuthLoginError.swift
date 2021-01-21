//
//  SSGoAuthLoginError..swift
//  Okee
//
//  Created by Son Nguyen on 12/5/20.
//

import Foundation
import FirebaseAuth

public enum SSGoAuthLoginError: Error {
    case unknown
    case invalidCredential
    case userDisabled
    case userNotFound
    case accountConflicted
    case networkError
    case noInternetError
    case tokenExpired
    
    static func convertedError(forErorr error: Error) -> SSGoAuthLoginError {
        switch AuthErrorCode(rawValue: error._code) {
        case .wrongPassword, .invalidEmail, .invalidCredential:
            return .invalidCredential
        case .userDisabled:
            return .userDisabled
        case .userNotFound:
            return .userNotFound
        case .accountExistsWithDifferentCredential:
            return .accountConflicted
        case .networkError:
            if (error._userInfo?["NSUnderlyingError"] as? Error)?.isNoInternetError ?? false {
                return .noInternetError
            }
            return .networkError
        case .userTokenExpired:
            return .tokenExpired
        default:
            return .unknown
        }
    }
}
