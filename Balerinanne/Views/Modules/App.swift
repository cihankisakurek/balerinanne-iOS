
import Foundation
import ComposableArchitecture


struct AppState: Equatable {

    public var authToken: String?

    public var deviceToken: Data?

    public var email: String

    public var isEmailTextFieldDisabled: Bool

    public var isLoginButtonDisabled: Bool

    public var isPasswordTextFieldDisabled: Bool

    public var isRegisterButtonDisabled: Bool

    public var keychainCredentials: Credentials?

    public var password: String

    public var passwordConfirmation: String

    public var profilePictureURL: String?

    public var showRegistrationForm: Bool

    public var username: String




    init(

        authToken: String?,

        deviceToken: Data?,

        email: String,

        isEmailTextFieldDisabled: Bool,

        isLoginButtonDisabled: Bool,

        isPasswordTextFieldDisabled: Bool,

        isRegisterButtonDisabled: Bool,

        keychainCredentials: Credentials?,

        password: String,

        passwordConfirmation: String,

        profilePictureURL: String?,

        showRegistrationForm: Bool,

        username: String

    ){

        self.authToken = authToken

        self.deviceToken = deviceToken

        self.email = email

        self.isEmailTextFieldDisabled = isEmailTextFieldDisabled

        self.isLoginButtonDisabled = isLoginButtonDisabled

        self.isPasswordTextFieldDisabled = isPasswordTextFieldDisabled

        self.isRegisterButtonDisabled = isRegisterButtonDisabled

        self.keychainCredentials = keychainCredentials

        self.password = password

        self.passwordConfirmation = passwordConfirmation

        self.profilePictureURL = profilePictureURL

        self.showRegistrationForm = showRegistrationForm

        self.username = username

    }

    public var appuserState: AppUserState {
        get {
            .init(

                authToken: authToken,

                email: email,

                isEmailTextFieldDisabled: isEmailTextFieldDisabled,

                isLoginButtonDisabled: isLoginButtonDisabled,

                isPasswordTextFieldDisabled: isPasswordTextFieldDisabled,

                isRegisterButtonDisabled: isRegisterButtonDisabled,

                password: password,

                passwordConfirmation: passwordConfirmation,

                profilePictureURL: profilePictureURL,

                showRegistrationForm: showRegistrationForm,

                username: username

            )

        }
        set {

            authToken = newValue.authToken

            email = newValue.email

            isEmailTextFieldDisabled = newValue.isEmailTextFieldDisabled

            isLoginButtonDisabled = newValue.isLoginButtonDisabled

            isPasswordTextFieldDisabled = newValue.isPasswordTextFieldDisabled

            isRegisterButtonDisabled = newValue.isRegisterButtonDisabled

            password = newValue.password

            passwordConfirmation = newValue.passwordConfirmation

            profilePictureURL = newValue.profilePictureURL

            showRegistrationForm = newValue.showRegistrationForm

            username = newValue.username

        }
    }
    


}

enum AppAction: Equatable {

    case appDidFinishLaunching

    case didRegisterForRemoteNotifications(Result<Data, NSError>)

    case didLoadCredentials(Result<Credentials, NSError>)



    case appuserAction(AppUserAction)


}

/*
let reducer = Reducer<Fundamentals.AuthenticationState, Fundamentals.AuthenticationAction, Fundamentals.AuthenticationEnvironment> {
    state, action, environment in
    
    switch action {
        
    }
}

*/
