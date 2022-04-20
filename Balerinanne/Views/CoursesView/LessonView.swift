//
//  LessonView.swift
//  Herrl
//
//  Created by Cihan Kisakurek on 20.04.22.
//

import SwiftUI
import ComposableArchitecture
import AVKit

struct LessonsView: View {
    
    let store: Store<IdentifiedArrayOf<LessonState>, (LessonState.ID, LessonAction)>
    
    @State private var showVideoPlayer = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section("Videos") {
                    ForEachStore(store) { store in
                        WithViewStore(store) { viewStore in
                            LessonView(store: store)
                                .fullScreenCover(
                                    isPresented: $showVideoPlayer,
                                    onDismiss: { showVideoPlayer = false }) {
                                        VideoPlayer(player: AVPlayer(url:  viewStore.videoURL))
                                            .edgesIgnoringSafeArea(.all)
                                    
                                }
                                .onTapGesture {
                                    showVideoPlayer = true
                                }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}

struct LessonView: View {
    
    let store: Store<LessonState, LessonAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
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
                Text(viewStore.description)
            }
            
            
            
        }
        
    }
}
