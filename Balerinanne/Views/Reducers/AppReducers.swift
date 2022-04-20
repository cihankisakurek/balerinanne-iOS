//
//  Reducers.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import Foundation
import ComposableArchitecture


struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    public var loadCredentials: (_ server: String) -> Effect<Credentials, NSError>
    
    static let live = Self(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                           loadCredentials: loadCredentials(server:))
}


let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
        case .appDidFinishLaunching:
            return environment.loadCredentials("localhost")
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(AppAction.didLoadCredentials)
        case .didRegisterForRemoteNotifications(_):
            return .none
        case let .didLoadCredentials(.success(credentials)):
            state.email = credentials.account
            state.password = credentials.password
            return .none
        case .didLoadCredentials(.failure(_)):
            return .none
        case .appuserAction(_):
            return .none
    
    }
}
    .combined(with:
            userReducer.pullback(
                state: \AppState.appuserState,
                action: /AppAction.appuserAction,
                environment: { _ in .live}))
    




