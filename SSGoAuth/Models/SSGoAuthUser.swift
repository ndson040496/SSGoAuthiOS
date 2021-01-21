//
//  SSGoAuthUser.swift
//  Okee
//
//  Created by Son Nguyen on 11/30/20.
//

import Foundation
import FirebaseAuth
import SSeoUtilities

public struct SSGoAuthUser: Codable {
    let uid: String
    let disabled: Bool
    let displayName: String
    let email: String
    let emailVerified: Bool
    let metadata: UserMetadata
    let multiFactor: MultiFactorSettings?
    let phoneNumber: String?
    let photoURL: String?
    let providerData: [UserInfo]
    let tenantId: String?
    
    init(fromUser user: User) {
        self.uid = user.uid
        self.disabled = false
        self.displayName = user.displayName ?? ""
        self.email = user.email ?? ""
        self.emailVerified = user.isEmailVerified
        self.metadata = UserMetadata(fromData: user.metadata)
        self.multiFactor = MultiFactorSettings(enrolledFactors: user.multiFactor.enrolledFactors.map({ (factorInfo) -> MultiFactorSettings.MultiFactorInfo in
            return MultiFactorSettings.MultiFactorInfo(fromInfo: factorInfo)
        }))
        self.phoneNumber = user.phoneNumber
        self.photoURL = user.photoURL?.absoluteString
        self.providerData = user.providerData.map({ (info) -> UserInfo in
            return UserInfo(fromInfo: info)
        })
        self.tenantId = user.tenantID
    }
    
    struct UserMetadata: Codable {
        let creationTime: String?
        let lastRefreshTime: String?
        let lastSignInTime: String?
        
        init(fromData data: FirebaseAuth.UserMetadata) {
            self.creationTime = data.creationDate?.utcString
            self.lastSignInTime = data.lastSignInDate?.utcString
            self.lastRefreshTime = nil
        }
    }
    
    struct MultiFactorSettings: Codable {
        
        let enrolledFactors: [MultiFactorInfo]
        
        struct MultiFactorInfo: Codable {
            let displayName: String?
            let enrollmentTime: String?
            let factorId: String
            let uid: String
            
            init(fromInfo info: FirebaseAuth.MultiFactorInfo) {
                self.displayName = info.displayName
                self.enrollmentTime = info.enrollmentDate.utcString
                self.factorId = info.factorID
                self.uid = info.uid
            }
        }
    }
    
    struct UserInfo: Codable {
        let displayName: String?
        let email: String?
        let phoneNumber: String?
        let photoURL: String?
        let providerId: String
        let uid: String
        
        init(fromInfo info: FirebaseAuth.UserInfo) {
            self.displayName = info.displayName
            self.email = info.email
            self.phoneNumber = info.phoneNumber
            self.photoURL = info.photoURL?.absoluteString
            self.providerId = info.providerID
            self.uid = info.uid
        }
    }
}
