//
//  CourseView.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import SwiftUI
import ComposableArchitecture

struct CourseView: View {

    let store: Store<CourseState, CourseAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.description)
                    .padding()
                let lessonsStore = store.scope(state: \.lessons, action: CourseAction.lessons(id:action:))
                LessonsView(store: lessonsStore)
            }
            .navigationTitle(viewStore.title)
        }
    }
}

