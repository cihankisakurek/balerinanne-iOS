
import Foundation
import ComposableArchitecture


struct AuthenticationState: Equatable {

    public var email: String

    public var password: String

    public var authToken: String?

    public var isLoginButtonDisabled: Bool

    public var isEmailTextFieldDisabled: Bool

    public var isPasswordTextFieldDisabled: Bool




    init(

        email: String,

        password: String,

        authToken: String?,

        isLoginButtonDisabled: Bool,

        isEmailTextFieldDisabled: Bool,

        isPasswordTextFieldDisabled: Bool

    ){

        self.email = email

        self.password = password

        self.authToken = authToken

        self.isLoginButtonDisabled = isLoginButtonDisabled

        self.isEmailTextFieldDisabled = isEmailTextFieldDisabled

        self.isPasswordTextFieldDisabled = isPasswordTextFieldDisabled

    }



}

enum AuthenticationAction: Equatable {

    case loginButtonTapped

    case saveCredentials

    case emailTextFieldChanged(String)

    case passwordTextFieldChanged(String)

    case authenticationResponse(Result<String?, NSError>)




}

/*
let reducer = Reducer<Fundamentals.AuthenticationState, Fundamentals.AuthenticationAction, Fundamentals.AuthenticationEnvironment> {
    state, action, environment in
    
    switch action {
        
    }
}

*/
