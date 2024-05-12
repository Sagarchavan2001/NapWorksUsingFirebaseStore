//
//  RegularExpressions.swift
//  NapWorks
//
//  Created by STC on 12/05/24.
//

import Foundation
class regularexpression{
    public static let shared = regularexpression()
    private init(){}

// MARK: - function For Invalid email ..
    public func regularexpressionForemail(_ value: String) -> String?{
        let rg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rg)
        if !predicate.evaluate(with: value)
        {
            return "Invalid Email Address"
        }
        return nil
        
    }
// MARK: - function For Invalid username..
     public func InvalidName(_ value: String) -> String?{
            let rg = "^[a-zA-Z' -]+$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", rg)
            if !predicate.evaluate(with: value)
            {
                return "Username Contains Only Characters"
            }
    return nil
        }
    
// MARK: - function For Invalid Password..
   public func InvalidPassword(_ value: String) -> String?{
        let rg = "[0-9]{6}$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", rg)
        if !predicate.evaluate(with: value)
        {
            return "password contains 6 Digits"
        }
return nil
    }
}
