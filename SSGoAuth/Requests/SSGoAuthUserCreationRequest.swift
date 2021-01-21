//
//  SSGoAuthUserCreationRequest.swift
//  Okee
//
//  Created by Son Nguyen on 11/30/20.
//

import Foundation
import SSeoNetwork

class SSGoAuthUserCreationRequest: SSNetworkRequest<SSGoAuthUser, SSGoAuthNetworkError> {
    
    enum UserType: String, Encodable {
        case email
    }
    
    init(usingEmail email: String, name: String, password: String) {
        let baseUrl = SSGoAuth.shared.userCreationDelegate?.authServiceUrl ?? ""
        let path = SSGoAuth.shared.userCreationDelegate?.path ?? []
        super.init(baseUrl: baseUrl, path: path, method: .POST)
        
        let userInfo = EmailUserInfo(email: email, displayName: name, password: password)
        setBody(userInfo)
        setContentType()
        SSGoAuth.shared.userCreationDelegate?.setAuthentication(request: self)
    }
    
    struct EmailUserInfo: Encodable {
        let type: UserType = .email
        let email: String
        let displayName: String
        let password: String
    }
}
