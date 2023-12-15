//
//  HoppiiJSs.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/23.
//

import Foundation

enum HoppiiJSs: String {
    /// Args: username, password
    case autoLogin = """
        document.getElementById("username").value = "%@";
        document.getElementById("password").value = "%@";
        document.getElementsByClassName("form-button")[0].click();
    """
    
    case checkLoginState = """
        document.getElementsByClassName('form-error').length > 0;
    """
}
