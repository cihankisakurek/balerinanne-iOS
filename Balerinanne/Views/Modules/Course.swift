//
//  Course.swift
//  Balerinanne
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import ComposableArchitecture

struct CourseState: Equatable, Identifiable {
    let id: UUID
    let mediaURL: String
    let title: String
    let description: String
    
    var lessons: IdentifiedArrayOf<LessonState> = []
}

enum CourseAction {
    case descriptionChanged(String)
    case lessons(id: LessonState.ID, action: LessonAction)
}



struct CoursesState: Equatable {
    var courses: IdentifiedArrayOf<CourseState> = []
}

enum CoursesAction {
    case course(id: CourseState.ID, action: CourseAction)
}

struct CoursesEnvironment: Equatable {
    public static let live = Self()
}


var courseReducer = Reducer<CourseState, CourseAction, CoursesEnvironment> {
    state, action, environment in
    switch action {

    case let .descriptionChanged(text):
        return .none
    case .lessons(id: let id, action: let action):
        return .none
    }
}

let coursesReducer = courseReducer.forEach(
    state: \CoursesState.courses,
    action: /CoursesAction.course(id:action:),
    environment: { (env: CoursesEnvironment) in CoursesEnvironment() }
)

