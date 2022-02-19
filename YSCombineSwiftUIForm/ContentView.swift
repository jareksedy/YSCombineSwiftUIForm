//
//  ContentView.swift
//  YSCombineSwiftUIForm
//
//  Created by Ярослав on 19.02.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var formViewModel = FormViewModel()
    @State var alertPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Введите имя пользователя"), footer: Text(formViewModel.userNameMessage).foregroundColor(.red)) {
                    TextField("Имя пользователя", text: $formViewModel.userName)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Введите пароль"), footer: Text(formViewModel.passwordMessage).foregroundColor(.red)) {
                    SecureField("Пароль", text: $formViewModel.password)
                    SecureField("Пароль повторно", text: $formViewModel.passwordAgain)
                }
                
                Section {
                    Button(action: { self.alertPresented = true }) { Text("Зарегистрироваться") }.disabled(!self.formViewModel.isValid)
                }
            }
            .sheet(isPresented: $alertPresented) { Text("Поздравляем с успешной регистрацией!") }
            .navigationTitle("Регистрация")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
