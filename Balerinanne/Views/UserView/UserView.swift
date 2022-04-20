//
//  UserView.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 18.04.22.
//


import SwiftUI
import ComposableArchitecture


struct UserView: View {
    
    let store: Store<AppUserState, AppUserAction>
    
    
    var authStore: Store<AuthenticationState, AuthenticationAction> {
        get {
            store.scope(state: { $0.authenticationState }, action: { .authenticationAction($0) })
        }
    }
    
    var registrationStore: Store<RegistrationState, RegistrationAction> {
        get {
            store.scope(state: { $0.registrationState }, action: { .registrationAction($0) })
        }
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    if viewStore.authToken != nil {
                        UserSettingsView(store: store)
                            .onAppear {
                                viewStore.send(.loadAppUserProfile)
                            }
                    }
                    else {
                        AuthenticationView(store: authStore)
                        Button("Register") {
                            viewStore.send(.toggleShowRegistrationForm)
                        }
                    }
                }
                .sheet(isPresented: .constant(viewStore.showRegistrationForm),
                       onDismiss: { viewStore.send(.toggleShowRegistrationForm) }) {
                    NavigationView {
                        RegistrationView(store: registrationStore)
                    }
                }
            }
        }
    }
}
