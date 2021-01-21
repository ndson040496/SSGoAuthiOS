//
//  SSGoAuth.swift
//  Okee
//
//  Created by Son Nguyen on 11/1/20.
//

import Foundation
import FirebaseAuth
import SSeoUtilities

public class SSGoAuth: SSLocoalizationSourceSetter {
    public static let shared = SSGoAuth()
    
    @Published public private(set) var isAuthenticated: Bool = false
    public private(set) var currentUser: SSGoAuthUser? {
        didSet {
            isAuthenticated = currentUser != nil
        }
    }
    public private(set) var accessToken: String?
    public private(set) var didLoginManually: Bool = false
    
    internal private(set) var legalDelegate: SSGoAuthLegalDelegate?
    internal private(set) var userCreationDelegate: SSGoAuthUserCreationDelegate?
    internal private(set) var generalDelegate: SSGoAuthGeneralDelegate?
    internal private(set) var appearanceDelegate: SSGoAuthAppearanceDelegate?
    
    private var accessTokenWaiter: [(String?) -> Void]? = []
    private var accessTokenTimer: SSTimer?
    
    private init() {
        if let user = Auth.auth().currentUser {
            self.startAccessTokenTimer(handler: { [weak self] (token) in
                self?.currentUser = SSGoAuthUser(fromUser: user)
                self?.accessTokenWaiter?.forEach({ (handler) in
                    handler(token)
                })
                self?.accessTokenWaiter = nil
            })
        } else {
            accessTokenWaiter?.forEach({ (handler) in
                handler(nil)
            })
            accessTokenWaiter = nil
        }
    }
    
    public func setup(withLegalDelegate legalDelegate: SSGoAuthLegalDelegate,
                      userCreationDelegate: SSGoAuthUserCreationDelegate,
                      appearanceDelegate: SSGoAuthAppearanceDelegate) {
        self.legalDelegate = legalDelegate
        self.userCreationDelegate = userCreationDelegate
        self.appearanceDelegate = appearanceDelegate
    }
    
    public func setStringSource(filename: String?, bundle: Bundle?) {
        if let filename = filename {
            SSGoAuthStrings.tableName = filename
        }
        if let bundle = bundle {
            SSGoAuthStrings.bundle = bundle
        }
    }
    
    public func setGeneralDelegate(_ delegate: SSGoAuthGeneralDelegate) {
        self.generalDelegate = delegate
    }
    
    public func waitForAccessToken(handler: @escaping (String?) -> Void) {
        if accessTokenWaiter == nil {
            handler(nil)
        } else {
            accessTokenWaiter?.append(handler)
        }
    }
    
    public func login(withEmail email: String, password: String, handler: @escaping (SSGoAuthUser?, SSGoAuthLoginError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let result = result, error == nil else {
                self?.currentUser = nil
                if let error = error {
                    handler(nil, SSGoAuthLoginError.convertedError(forErorr: error))
                }
                return
            }
            let user = SSGoAuthUser(fromUser: result.user)
            self?.startAccessTokenTimer(handler: { (token) in
                self?.currentUser = user
                self?.didLoginManually = true
                handler(user, nil)
            })
        }
    }
    
    public func sendResetPassword(toEmail email: String, handler: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            handler(error == nil)
        }
    }
    
    public func logout() {
        let task = { [weak self] in
            self?.accessTokenTimer?.invalidate();
            self?.accessTokenTimer = nil
            do {
                try Auth.auth().signOut()
                self?.currentUser = nil
            } catch {}
        }
        
        guard let delegate = self.generalDelegate else {
            task()
            return
        }
        
        delegate.onLogout {
            task()
        }
    }
    
    private func startAccessTokenTimer(handler: @escaping (String?) -> Void) {
        Auth.auth().currentUser?.getIDToken(completion: { [weak self] (token, _) in
            self?.accessToken = token
            handler(token)
            if let user = self?.currentUser {
                self?.generalDelegate?.onLoginSuccess(user: user)
            }
            self?.accessTokenTimer = SSTimer.scheduledTimer(withTimeInterval: 3601, repeats: true) {
                Auth.auth().currentUser?.getIDToken(completion: { [weak self] (token, _) in
                    self?.accessToken = token
                })
            }
        })
    }
}
 
