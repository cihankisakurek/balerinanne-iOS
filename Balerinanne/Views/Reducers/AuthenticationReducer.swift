//
//  AuthenticationReducer.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import Foundation
import ComposableArchitecture


struct AuthenticationEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    public var authenticate: (_ email: String, _ password: String) -> Effect<String?, NSError>
    public var saveToKeychain: (_ email: String, _ password: String) -> Void
    static let live = Self(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                           authenticate: authenticate(email:password:),
                           saveToKeychain: saveToKeychain(email:password:))
}

let authReducer = Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment> { state, action, environment in
    
    switch action {
        
    case .loginButtonTapped:
        // remove all errors before a new request
//        state.errors = []
        // Set the login button disabled so we dont send multiple requests
        state.isLoginButtonDisabled = true
        return environment.authenticate(state.email, state.password)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AuthenticationAction.authenticationResponse)
        
    case .emailTextFieldChanged(let text):
        state.email = text
        return .none
        
    case .passwordTextFieldChanged(let text):
        state.password = text
        return .none
        
    case let .authenticationResponse(.success(response)):
        state.isLoginButtonDisabled = false
        state.authToken = response
        return Effect(value: AuthenticationAction.saveCredentials)
//                  .delay(for: 1, scheduler: environment.mainQueue)
              .eraseToEffect()
        
    case let .authenticationResponse(.failure(error)):
//        state.errors.append(error)
        state.isLoginButtonDisabled = false
        return .none

    case .saveCredentials:
        let email = state.email
        let password = state.password
        return .fireAndForget {
            environment.saveToKeychain(email, password)
        }
    }
}


func authenticate(email: String, password: String) -> Effect<String?, NSError> {
    var urlRequest = URLRequest(url: URL(string: "http://localhost:80/api/authenticate")!)
    urlRequest.httpMethod = "POST"
    
    let params = ["email": email, "password": password]
    
    var data = [String]()
    for(key, value) in params
    {
        data.append(key + "=\(value)")
    }
    
    let postString = data.map { String($0) }.joined(separator: "&")
    urlRequest.httpBody = postString.data(using: .utf8)
    
    return URLSession.shared
        .dataTaskPublisher(for: urlRequest)
        .tryMap() { element -> String? in
            
            guard let httpResponse = element.response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badURL)
            }
            
            if let response = try? JSONDecoder().decode([String: String].self, from: element.data),
               let token = response["access_token"] {
                return token
            }
            return nil
            
        }
        .mapError { error -> NSError in
            // TODO: Create a more specific error
            let nsError = NSError(domain: "Fundamentals.AuthenticationError", code: -150, userInfo: [NSLocalizedDescriptionKey : "Cannot authenticaticate"])
            return nsError
        }
        .eraseToEffect()
}
