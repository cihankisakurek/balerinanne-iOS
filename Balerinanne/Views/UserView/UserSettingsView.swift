//
//  UserSettingsView.swift
//  Fundamentals
//
//  Created by Cihan Kisakurek on 11.04.22.
//

import SwiftUI
import ComposableArchitecture

struct UserSettingsView: View {

    let store: Store<AppUserState, AppUserAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Form {
                Section {
                    HStack {
                        NavigationLink(destination: EmptyView()) {
                            if let url = viewStore.profilePictureURL {
                                
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image(systemName: "person")
                                        .font(Font.title)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                                .frame(width: 50, height: 50)
                            }
                            else {
                                Image(systemName: "person")
                                    .font(Font.title)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                                
                            VStack(alignment: .leading) {
                                Text(viewStore.username)
                                    .font(.headline)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                                Text(viewStore.email)
                                    .font(.subheadline)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                    }

                }
                
                
                
                //                    DatePicker(selection: viewStore.binding(get: { $0.birthdate ?? Date() },
                //                                                            send: Fundamentals.UserSettingsAction.birthdateFieldChanged),
                //                               in: ...Date(), displayedComponents: .date) {
                //                        Text("Birthdate")
                //                    }

//                Section(header: Text("Device settings")) {
//                    Toggle(isOn: viewStore.binding(get: { $0.pushNotificationEnabled },
//                                                   send: Fundamentals.UserSettingsAction.pushNotificationEnabledChanged)) {
//                        Text("Notification Enabled")
//                    }
//                    Toggle(isOn: viewStore.binding(get: { $0.locationUpdatesEnabled },
//                                                   send: Fundamentals.UserSettingsAction.locationUpdatesEnabledChanged)) {
//                        Text("Location services Enabled")
//                    }
//                }
            }
            .navigationTitle("Profile")
        }
    }
}
