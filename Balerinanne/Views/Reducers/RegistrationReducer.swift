//
//  RegistrationReducer.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import Foundation
import ComposableArchitecture


struct RegistrationEnvironment {
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var register: (_ username: String, _ email: String, _ password: String, _ passwordConfirmation: String) -> Effect<String?, NSError>
    public var saveToKeychain: (_ email: String, _ password: String) -> Void
    static let live = Self(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                           register: register(username:email:password:passwordConfirmation:),
                           saveToKeychain: saveToKeychain(email:password:))
}

let registrationReducer = Reducer<RegistrationState, RegistrationAction, RegistrationEnvironment> { state, action, environment in
    
    switch action {
        
        case .registerButtonTapped:
            // remove all errors before a new request
//            state.errors = []
            // Set the login button disabled so we dont send multiple requests
            state.isRegisterButtonDisabled = true
            return environment.register(state.username, state.email, state.password, state.passwordConfirmation)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(RegistrationAction.registrationResponse)
        
        case let .usernameTextFieldChanged(text):
            state.username = text
            return .none
        case let .emailTextFieldChanged(text):
            state.email = text
            return .none
        case let .passwordTextFieldChanged(text):
            state.password = text
            return .none
        case let .passwordConfirmationTextFieldChanged(text):
            state.passwordConfirmation = text
            return .none
        case let .registrationResponse(.success(response)):
            state.isRegisterButtonDisabled = false
            state.authToken = response
        
            let email = state.email
            let password = state.password
            return .fireAndForget {
                environment.saveToKeychain(email, password)
            }
        case let .registrationResponse(.failure(error)):
//            state.errors.append(error)
            state.isRegisterButtonDisabled = false
            return .none
        
    case .saveCredentials:
        return .none
    }
}

func register(username: String, email: String, password: String, passwordConfirmation: String) -> Effect<String?, NSError> {
    var urlRequest = URLRequest(url: URL(string: "http://localhost/api/register")!)
    urlRequest.httpMethod = "POST"
    
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let params = ["name": username, "email": email, "password": password, "password_confirmation": passwordConfirmation]

    let json = try! JSONEncoder().encode(params)
    urlRequest.httpBody = json
    
    return URLSession.shared
        .dataTaskPublisher(for: urlRequest)
        .tryMap() { element -> String? in
            
            
                    let str = String(data: element.data, encoding: .utf8)
                    print(str)
            
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
