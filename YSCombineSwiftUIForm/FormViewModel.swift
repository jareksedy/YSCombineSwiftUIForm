//
//  FormViewModel.swift
//  YSCombineSwiftUIForm
//
//  Created by Ярослав on 19.02.2022.
//

import Combine

class FormViewModel: ObservableObject {
    // input
    @Published var userName = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    // output
    @Published var isValid = false
}
