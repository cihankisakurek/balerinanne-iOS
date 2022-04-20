//
//  Functions.swift
//  Balerinanne
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import Foundation
import ComposableArchitecture

public struct Credentials: Equatable {
    public var account: String
    public var password: String
}

public struct AppUser: Equatable, Decodable {
    public var username: String
    public var email: String
    public var profilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "name"
        case email
        case profilePicture = "profile_photo_url"
        
    }
    
    public init(username: String, email: String) {
        self.username = username
        self.email = email
    }
}



func saveToKeychain(email: String, password: String) {
    
    let server = "localhost"
    let account = email
    let password = password.data(using: String.Encoding.utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrServer as String: server,
                                kSecValueData as String: password]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
        //                throw KeychainError.unhandledError(status: status)
        return;
    }
}

func loadCredentials(server: String) -> Effect<Credentials, NSError> {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else {
        return Effect(error: NSError(domain: "OSEnvironment", code: -12, userInfo: [:]))
        
    }
    guard status == errSecSuccess else {
        return Effect(error: NSError(domain: "OSEnvironment", code: -13, userInfo: [:]))
        
    }
    
    guard let existingItem = item as? [String : Any],
          let passwordData = existingItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: String.Encoding.utf8),
          let account = existingItem[kSecAttrAccount as String] as? String
    else {
        return Effect(error: NSError(domain: "OSEnvironment", code: -14, userInfo: [:]))
    }
    return Effect(value: Credentials(account: account, password: password))
}
