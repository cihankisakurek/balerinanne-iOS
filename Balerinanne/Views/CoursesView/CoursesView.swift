//
//  CoursesView.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import SwiftUI

import ComposableArchitecture

struct CoursesView: View {
    
    let store: Store<CoursesState, CoursesAction>
    
    var body: some View {
        NavigationView {
            List {
                ForEachStore(self.store.scope(state: \.courses, action: CoursesAction.course(id:action:))) { store in
                    NavigationLink(destination: CourseView(store: store)) {
                        CoursesCellView(store: store)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Courses")
        }
    }
}

struct CoursesCellView: View {
    
    let store: Store<CourseState, CourseAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                AsyncImage(url: URL(string: "")) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo")
                        .font(Font.title)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .frame(width: 50, height: 50)
                .padding(0)
            }
            VStack (alignment: .leading) {
                Text(viewStore.title)
                    .font(.subheadline)
                Text(viewStore.description)
                    .font(.caption2)
            }
        }
    }
}
