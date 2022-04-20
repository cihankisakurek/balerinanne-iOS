//
//  UserView.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 18.04.22.
//


import SwiftUI
import ComposableArchitecture


struct RegistrationView: View {
    
    let store: Store<RegistrationState, RegistrationAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Form {
                
                let usernameBinding = viewStore.binding(get: { $0.username}, send: { .usernameTextFieldChanged($0) })
                TextField("Username", text: usernameBinding)
                
                let emailBinding = viewStore.binding(get: { $0.email}, send: { .emailTextFieldChanged($0) })
                TextField("Email", text: emailBinding)
                
                let passwordBinding = viewStore.binding(get: { $0.password}, send: { .passwordTextFieldChanged($0) })
                TextField("Password", text: passwordBinding)
                
                let passwordConfirmationBinding = viewStore.binding(get: { $0.passwordConfirmation}, send: { .passwordConfirmationTextFieldChanged($0) })
                TextField("Password Confirmation", text: passwordConfirmationBinding)
                Button(action: {
                    viewStore.send(.registerButtonTapped)
                 }) {
                     Text("Register")
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
                 .disabled(viewStore.isRegisterButtonDisabled)
                 .padding(EdgeInsets(top: 16, leading: 8, bottom: 4, trailing: 8))
                
//                Section {
////                    if let message = viewStore.errors.first {
////                        Text(message.localizedDescription)
////                    }
//                }

            }
            .navigationTitle("Registration")
        }
    }
}
