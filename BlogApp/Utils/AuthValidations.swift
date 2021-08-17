//
//  AuthValidations.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/13/21.
//

import Foundation

class AuthValidations{
    
    public static func isValidEmail(testStr:String) -> Bool {
              let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
              let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                let result = emailTest.evaluate(with: testStr)
              return result
          }
    
    
    public static func passwordLength(string: String) -> Bool {
        if string.count < 6{
            return false
        }else{
            return true
        }
    }
    
    
    public static func passwordMatch(pass1: String, pass2: String) -> Bool{
        if pass1 == pass2{
            return true
        }else{
            return false
        }
    }
}
