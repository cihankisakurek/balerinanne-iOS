
import Foundation
import ComposableArchitecture


struct AppUserState: Equatable {

    public var authToken: String?

    public var email: String

    public var isEmailTextFieldDisabled: Bool

    public var isLoginButtonDisabled: Bool

    public var isPasswordTextFieldDisabled: Bool

    public var isRegisterButtonDisabled: Bool

    public var password: String

    public var passwordConfirmation: String

    public var profilePictureURL: String?

    public var showRegistrationForm: Bool

    public var username: String




    init(

        authToken: String?,

        email: String,

        isEmailTextFieldDisabled: Bool,

        isLoginButtonDisabled: Bool,

        isPasswordTextFieldDisabled: Bool,

        isRegisterButtonDisabled: Bool,

        password: String,

        passwordConfirmation: String,

        profilePictureURL: String?,

        showRegistrationForm: Bool,

        username: String

    ){

        self.authToken = authToken

        self.email = email

        self.isEmailTextFieldDisabled = isEmailTextFieldDisabled

        self.isLoginButtonDisabled = isLoginButtonDisabled

        self.isPasswordTextFieldDisabled = isPasswordTextFieldDisabled

        self.isRegisterButtonDisabled = isRegisterButtonDisabled

        self.password = password

        self.passwordConfirmation = passwordConfirmation

        self.profilePictureURL = profilePictureURL

        self.showRegistrationForm = showRegistrationForm

        self.username = username

    }

    public var authenticationState: AuthenticationState {
        get {
            .init(

                email: email,

                password: password,

                authToken: authToken,

                isLoginButtonDisabled: isLoginButtonDisabled,

                isEmailTextFieldDisabled: isEmailTextFieldDisabled,

                isPasswordTextFieldDisabled: isPasswordTextFieldDisabled

            )

        }
        set {

            email = newValue.email

            password = newValue.password

            authToken = newValue.authToken

            isLoginButtonDisabled = newValue.isLoginButtonDisabled

            isEmailTextFieldDisabled = newValue.isEmailTextFieldDisabled

            isPasswordTextFieldDisabled = newValue.isPasswordTextFieldDisabled

        }
    }
    
    public var registrationState: RegistrationState {
        get {
            .init(

                username: username,

                email: email,

                password: password,

                passwordConfirmation: passwordConfirmation,

                authToken: authToken,

                isRegisterButtonDisabled: isRegisterButtonDisabled

            )

        }
        set {

            username = newValue.username

            email = newValue.email

            password = newValue.password

            passwordConfirmation = newValue.passwordConfirmation

            authToken = newValue.authToken

            isRegisterButtonDisabled = newValue.isRegisterButtonDisabled

        }
    }
    


}

enum AppUserAction: Equatable {

    case toggleShowRegistrationForm

    case loadAppUserProfile

    case didLoadAppUser(Result<AppUser, NSError>)



    case authenticationAction(AuthenticationAction)

    case registrationAction(RegistrationAction)


}

/*
let reducer = Reducer<Fundamentals.AuthenticationState, Fundamentals.AuthenticationAction, Fundamentals.AuthenticationEnvironment> {
    state, action, environment in
    
    switch action {
        
    }
}

*/
