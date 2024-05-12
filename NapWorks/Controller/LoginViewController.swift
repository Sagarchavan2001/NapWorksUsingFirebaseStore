//
//  LoginViewController.swift
//  NapWorks
//
//  Created by STC on 11/05/24.
//

import UIKit

class LoginViewController: UIViewController {
    
// MARK: - outlets for textfields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreForm1()
    }
    
    func restoreForm1(){
        loginButton.isEnabled = false
        usernameError.isHidden = true
        emailError.isHidden = true
        passwordError.isHidden = true
    }
    
    
    @IBAction func UsernameTextfield1(_ sender: Any) {
        if let userName = usernameTextField.text{
            if let errorMessage =  regularexpression.shared.InvalidName(userName){
                usernameError.text = errorMessage
                usernameError.isHidden = false
            }else{
                usernameError.isHidden = true
            }
            checkForm()
        }
    }
    @IBAction func EmailTextfield1(_ sender: Any) {
        if let EmailId = emailTextField.text{
            if let errorMessage = regularexpression.shared.regularexpressionForemail(EmailId){
                emailError.text = errorMessage
                emailError.isHidden = false
            }else{
                emailError.isHidden = true
            }
            checkForm()
        }
        
    }
  
    
    @IBAction func passwordTextfield(_ sender: Any) {
        if let Password = passwordTextField.text{
            if let errorMessage =  regularexpression.shared.InvalidPassword(Password){
                passwordError.text = errorMessage
                passwordError.isHidden = false
            }else{
                passwordError.isHidden = true
            }
            checkForm()
        }
        
    }

    
func checkForm(){
        if usernameError.isHidden && emailError.isHidden && passwordError.isHidden && usernameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false  && passwordTextField.text?.isEmpty == false {
            loginButton.isEnabled = true
        }else{
            loginButton.isEnabled = false
        }
    }

    // MARK: - Function For Login Button
    
    @IBAction func loginBtn(_ sender: Any) {
        let userrequest = registerUserRequest(userName: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
        AuthServices.shared.registerUser(with: userrequest) { wasRegistered, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            print("user register",wasRegistered)
            let vc = HomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav,animated: false,completion: nil)
        }
        
    }
    

}
