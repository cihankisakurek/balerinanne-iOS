//
//  Lesson.swift
//  Balerinanne
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import ComposableArchitecture

struct LessonsState: Equatable {
    
}
enum LessonsAction {
    case lesson(id: LessonState.ID, action: LessonAction)
}

struct LessonState: Equatable, Identifiable {
    let id: UUID
    let videoURL: URL
    let title: String
    let description: String
}
enum LessonAction {
    case watch
}
