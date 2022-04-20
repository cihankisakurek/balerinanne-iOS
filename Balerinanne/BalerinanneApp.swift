//
//  BalerinanneApp.swift
//  Balerinanne
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import SwiftUI
import ComposableArchitecture

func createMockLessons() -> IdentifiedArrayOf<LessonState>? {

    guard let path = Bundle.main.path(forResource: "RainForest", ofType:"mp4") else {
                debugPrint("video.m4v not found")
        return nil
    }
    
    let url = URL(fileURLWithPath: path)
    
    let lessons: IdentifiedArrayOf<LessonState> = [
        LessonState(id: UUID(),
                    videoURL: url,
                    title: "Lesson Title ",
                    description: "Lesson description")
    ]
    return lessons
}




let courses: IdentifiedArrayOf<CourseState> = [
    CourseState(id: UUID(), mediaURL: "", title: "Course Title 1", description: "Course description", lessons: createMockLessons()!)
]


@main
struct BalerinanneApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                let store = Store<CoursesState, CoursesAction>(initialState: CoursesState(courses: courses),
                                                               reducer: coursesReducer, environment: .live)
                
                CoursesView(store: store)
                    .tabItem {
                        Label("Courses", systemImage: "list.dash")
                    }
                
                let userStore = appDelegate.store.scope(state: { $0.appuserState }, action: { .appuserAction($0) })
                UserView(store: userStore)
                    .tabItem {
                        Label("Authentication", systemImage: "person.fill")
                    }
            }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    public static let state = AppState(authToken: nil,
                                       deviceToken: nil,
                                       email: "",
                                       isEmailTextFieldDisabled: false,
                                       isLoginButtonDisabled: false,
                                       isPasswordTextFieldDisabled: false,
                                       isRegisterButtonDisabled: false,
                                       keychainCredentials: nil,
                                       password: "",
                                       passwordConfirmation: "",
                                       profilePictureURL: nil,
                                       showRegistrationForm: false,
                                       username: "")
    
    
    let store: Store<AppState, AppAction> = Store(initialState: AppDelegate.state , reducer: appReducer, environment: .live )
    lazy var viewStore = ViewStore(self.store.scope(state: { _ in () }), removeDuplicates: ==)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        self.viewStore.send(.appDidFinishLaunching)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.viewStore.send(.didRegisterForRemoteNotifications(.success(deviceToken)))
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.viewStore.send(.didRegisterForRemoteNotifications(.failure(error as NSError)))
    }
}
