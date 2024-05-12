//
//  HomeViewController.swift
//  NapWorks
//
//  Created by STC on 11/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class HomeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // MARK: - IBoutlets
    
    @IBOutlet weak var profileImage1: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailIDTextfield: UITextField!
    @IBOutlet weak var dateofBirthTextField: UITextField!
    @IBOutlet weak var userIdTextfield: UITextField!
    @IBOutlet weak var switchbtn: UISwitch!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var emailerror: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    let datepicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "...Profile..."
        setlogoutButton()
        FetcherUserData()
        profileImage()
        swichbutton()
        createDatePicker()
        restoreForm2()
    }
    
    func restoreForm2(){
        saveButton.isEnabled = false
        usernameError.isHidden = true
        emailerror.isHidden = true
    }
    @IBAction func usernameTextField2(_ sender: Any) {
        if let userName = nameTextField.text{
            if let errorMessage =  regularexpression.shared.InvalidName(userName){
                usernameError.text = errorMessage
                usernameError.isHidden = false
            }else{
                usernameError.isHidden = true
            }
            checkForm()
        }
    }
    @IBAction func emailtextfield2(_ sender: Any) {
        if let EmailId = emailIDTextfield.text{
        if let errorMessage =  regularexpression.shared.regularexpressionForemail(EmailId){
                emailerror.text = errorMessage
                emailerror.isHidden = false
        }else{
        emailerror.isHidden = true
         }
        checkForm()
        }
    }
    func checkForm(){
        if usernameError.isHidden && emailerror.isHidden && nameTextField.text?.isEmpty == false && emailIDTextfield.text?.isEmpty == false  && dateofBirthTextField.text?.isEmpty == false && userIdTextfield.text?.isEmpty == false {
                saveButton.isEnabled = true
        }else{
        saveButton.isEnabled = false
        }
        }

    // MARK: - Save Button..
    @IBAction func savebtn(_ sender: Any) {
        saveUpdateInfo()
        print("saving success....")
    }
// MARK: - Function for update data in Firestore
    func saveUpdateInfo(){
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        let usermail = Auth.auth().currentUser?.email
        let currentUser = Auth.auth().currentUser
        if nameTextField.text != nil && emailIDTextfield.text != nil && dateofBirthTextField.text != nil && userIdTextfield != nil{
            db.collection("users").document("\(userId!)").updateData(["email":emailIDTextfield.text!, "username":nameTextField.text!])
            if emailIDTextfield.text != usermail{
                let alert = UIAlertController(title: "Send Link", message: "On Current Email Id", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                currentUser?.sendEmailVerification(beforeUpdatingEmail: emailIDTextfield.text!){
                    error in
            if let error = error{
                        print(error)
                    }
                }
            }
        
// MARK: - Add DoB Field in firestore database
            db.collection("users")
                .document("\(userId!)").setData(["DoB": dateofBirthTextField.text!], merge: true)
        }
    }
    
// MARK: - Creating toolbar for datepicker
    func cretetoolbar()->UIToolbar{
       let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action:  #selector(cancelPress))
        toolbar.setItems([doneBtn,cancelBtn], animated: true)
        return toolbar
    }
    func createDatePicker(){
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.datePickerMode = .date
        dateofBirthTextField.inputView = datepicker
        dateofBirthTextField.inputAccessoryView = cretetoolbar()
    }
    @objc  func donePress(){
        let dateformatter = DateFormatter()
       
       dateformatter.dateFormat = "dd/MM/yyyy"
        
        self.dateofBirthTextField.text = dateformatter.string(from: datepicker.date)
        self.view.endEditing(true)
        
    }
    @objc  func cancelPress(){
        self.view.endEditing(true)
    }
    
// MARK: - Function for Fetch User Data from Firestore
    func FetcherUserData(){
        AuthServices.shared.fetchUser { [weak self] user, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let user = user{
                self?.nameTextField.text = "\(user.username)"
                self?.emailIDTextfield.text = "\(user.userEmail)"
                self?.userIdTextfield.text = "\(user.userId)"
            }
        }
    }
    
// MARK: - Function For Editing Mode On/off
    func swichbutton(){
        
        switchbtn.isOn = false
        self.nameTextField.isUserInteractionEnabled = false
        self.emailIDTextfield.isUserInteractionEnabled = false
        self.dateofBirthTextField.isUserInteractionEnabled = false
        self.userIdTextfield.isUserInteractionEnabled = false
    }
    @IBAction func SwichButton(_ sender: UISwitch) {
        if sender.isOn{
            self.nameTextField.isUserInteractionEnabled = true
            self.emailIDTextfield.isUserInteractionEnabled = true
            self.dateofBirthTextField.isUserInteractionEnabled = true
            self.userIdTextfield.isUserInteractionEnabled = true
        }else{
            self.nameTextField.isUserInteractionEnabled = false
            self.emailIDTextfield.isUserInteractionEnabled = false
            self.dateofBirthTextField.isUserInteractionEnabled = false
            self.userIdTextfield.isUserInteractionEnabled = false
        }
    }
   
// MARK: - Function For Profile Image and gallary
    func profileImage(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage1.isUserInteractionEnabled = true
        profileImage1.addGestureRecognizer(tapGestureRecognizer)
        profileImage1.layer.cornerRadius = 75
        profileImage1.clipsToBounds = true
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let imageController = UIImagePickerController()
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imageController.isEditing = true
        imageController.delegate = self
        self.present(imageController, animated: true,completion: nil)
  
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage1.image = selectedImage
        picker.dismiss(animated: true,completion: nil)
    }
    
// MARK: - Function For Logout Button
     private func setlogoutButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didtaplogout))
    }
    @objc private func didtaplogout(){
        AuthServices.shared.signOut { error in
            guard let error = error else{
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
                    sceneDelegate.checkAuthentication()
                }
                return
            }
            print(error.localizedDescription)
           
            }
        }
    }

