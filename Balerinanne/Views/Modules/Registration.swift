
import Foundation
import ComposableArchitecture


struct RegistrationState: Equatable {

    public var username: String

    public var email: String

    public var password: String

    public var passwordConfirmation: String

    public var authToken: String?

    public var isRegisterButtonDisabled: Bool




    init(

        username: String,

        email: String,

        password: String,

        passwordConfirmation: String,

        authToken: String?,

        isRegisterButtonDisabled: Bool

    ){

        self.username = username

        self.email = email

        self.password = password

        self.passwordConfirmation = passwordConfirmation

        self.authToken = authToken

        self.isRegisterButtonDisabled = isRegisterButtonDisabled

    }



}

enum RegistrationAction: Equatable {

    case registerButtonTapped

    case saveCredentials

    case usernameTextFieldChanged(String)

    case emailTextFieldChanged(String)

    case passwordTextFieldChanged(String)

    case passwordConfirmationTextFieldChanged(String)

    case registrationResponse(Result<String?, NSError>)




}

/*
let reducer = Reducer<Fundamentals.AuthenticationState, Fundamentals.AuthenticationAction, Fundamentals.AuthenticationEnvironment> {
    state, action, environment in
    
    switch action {
        
    }
}

*/
