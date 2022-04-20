//
//  AppUserReducer.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import Foundation
import ComposableArchitecture



struct AppUserProfile {
    
}

struct AppUserEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    public var loadAppUserProfile: (_ token: String?) -> Effect<AppUser, NSError>
    static let live = Self(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                           loadAppUserProfile: loadAppUserProfile(token:))
}


let userReducer = Reducer<AppUserState, AppUserAction, AppUserEnvironment> { state, action, environment in
    switch action {
        case .authenticationAction(_):
            return .none
        case .registrationAction(_):
            return .none
        case .toggleShowRegistrationForm:
            state.showRegistrationForm.toggle()
        return .none
        case .loadAppUserProfile:
            return environment.loadAppUserProfile(state.authToken)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(AppUserAction.didLoadAppUser)
        case let .didLoadAppUser(.success(user)):
            state.username = user.username
            state.email = user.email
            state.profilePictureURL = user.profilePicture
            return .none
        case let .didLoadAppUser(.failure(error)):
            return .none
    }
}
    .combined(with:
        authReducer.pullback(
            state: \AppUserState.authenticationState,
            action: /AppUserAction.authenticationAction,
            environment: { _ in .live})

)
    .combined(with:
                registrationReducer.pullback(
                    state: \.registrationState,
                    action: /AppUserAction.registrationAction,
                    environment: { _ in .live }))


func loadAppUserProfile(token: String?) -> Effect<AppUser, NSError> {
    
    guard let token = token else {
        return .none
    }

    
    var urlRequest = URLRequest(url: URL(string: "http://localhost:80/api/me")!)
    urlRequest.httpMethod = "GET"
    
    urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    
//    let params = ["email": email, "password": password]
//
//    var data = [String]()
//    for(key, value) in params
//    {
//        data.append(key + "=\(value)")
//    }
    
//    let postString = data.map { String($0) }.joined(separator: "&")
//    urlRequest.httpBody = postString.data(using: .utf8)
    
    return URLSession.shared
        .dataTaskPublisher(for: urlRequest)
        .tryMap() { element -> AppUser in
            
//            let str = String(data: element.data, encoding: .utf8)
//            print(str)
            
            guard let httpResponse = element.response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badURL)
            }
            
            return try JSONDecoder().decode(AppUser.self, from: element.data)
//            if let response =
//                return response
//            }
//            throw URLError(.badURL)
//            return Fundamentals.AppUser(username: "", email: "")
            
        }
        .mapError { error -> NSError in
            // TODO: Create a more specific error
            let nsError = NSError(domain: "Fundamentals.AuthenticationError", code: -150, userInfo: [NSLocalizedDescriptionKey : "Cannot authenticaticate"])
            return nsError
        }
        .eraseToEffect()
}
