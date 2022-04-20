//
//  AuthenticationView.swift
//  ComposableUI
//
//  Created by Cihan Kisakurek on 04.04.22.
//

import SwiftUI

import ComposableArchitecture

struct AuthenticationView: View {
    
    let store: Store<AuthenticationState, AuthenticationAction>
    
    var body: some View {
        VStack {
            WithViewStore(self.store) { viewStore in
                
                TextField("Email", text: viewStore.binding(get: { $0.email },
                                                           send: AuthenticationAction.emailTextFieldChanged))
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                TextField("Password", text: viewStore.binding(get: { $0.password },
                                                              send: AuthenticationAction.passwordTextFieldChanged))
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                
                Button(action: {
                    viewStore.send(.loginButtonTapped)
                 }) {
                     Text("Login")
                         .frame(minWidth: 0, maxWidth: .infinity)
                         .font(.system(size: 18))
                         .padding()
                         .foregroundColor(.white)
                         .overlay(
                             RoundedRectangle(cornerRadius: 25)
                                 .stroke(Color.clear, lineWidth: 2)
                     )
                 }
                 .background(Color.accentColor) // If you have this
                 .cornerRadius(25)         // You also need the cornerRadius here
                 .disabled(viewStore.isLoginButtonDisabled)
                 .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
            }
        }
    }
}
