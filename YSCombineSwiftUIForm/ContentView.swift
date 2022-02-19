//
//  ContentView.swift
//  YSCombineSwiftUIForm
//
//  Created by Ярослав on 19.02.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var formViewModel = FormViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Введите имя пользователя") {
                    TextField("Имя пользователя", text: $formViewModel.userName)
                        .autocapitalization(.none)
                }
                
                Section("Введите пароль") {
                    SecureField("Пароль", text: $formViewModel.password)
                    SecureField("Пароль повторно", text: $formViewModel.passwordAgain)
                }
                
                Section {
                    Button(action: {}) { Text("Зарегистрироваться") }.disabled(!self.formViewModel.isValid)
                }
            }
            .navigationTitle("Регистрация")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
