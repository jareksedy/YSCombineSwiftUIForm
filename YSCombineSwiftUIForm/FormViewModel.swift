//
//  FormViewModel.swift
//  YSCombineSwiftUIForm
//
//  Created by Ярослав on 19.02.2022.
//

import Combine
import Foundation
import SwiftUI

class FormViewModel: ObservableObject {
    enum PasswordCriteria {
        case valid
        case empty
        case doNotMatch
    }
    
    // input
    @Published var userName = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    // output
    @Published var isValid = false
    @Published var userNameMessage = ""
    @Published var passwordMessage = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        isUserNameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Имя пользователя должно содержать минимум 3 символа!"
            }
            .assign(to: \.userNameMessage, on: self)
            .store(in: &subscriptions)
        
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCriteria in
                switch passwordCriteria {
                case .doNotMatch: return "Пароли не совпадают."
                case .empty: return "Пароль не должен быть пустым."
                case .valid: return ""
                }
            }
            .assign(to: \.passwordMessage, on: self)
            .store(in: &subscriptions)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &subscriptions)
    }
    
    // private publishers
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUserNameValidPublisher, isPasswordValidPublisher)
            .map { userNameIsValid, passwordIsValid in
                return userNameIsValid && (passwordIsValid == .valid)
            }
            .eraseToAnyPublisher()
    }
    
    private var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
        $userName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCriteria, Never> {
        Publishers.CombineLatest(isPasswordEmptyPublisher, passwordsMatchPublisher)
            .map { passwordEmpty, passwordsMatch in
                if passwordEmpty { return .empty }
                if !passwordsMatch { return .doNotMatch }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordsMatchPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password, passwordAgain in
                return password == passwordAgain
            }
            .eraseToAnyPublisher()
    }
}
