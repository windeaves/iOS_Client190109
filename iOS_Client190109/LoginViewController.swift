//
//  LoginViewController.swift
//  iOS_Client190109
//
//  Created by 唐子轩 on 2019/1/11.
//  Copyright © 2019 TonyTang. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var salt:   String = ""
    var hashed: String = ""
    
    // MARK: Setup Haptic Feedback
    let hapticImpactLight  = UIImpactFeedbackGenerator(style: .light)
    let hapticImpactMedium = UIImpactFeedbackGenerator(style: .medium)
    let hapticImpactHeavy  = UIImpactFeedbackGenerator(style: .heavy)
    let hapticSelection    = UISelectionFeedbackGenerator()
    let hapticNotification = UINotificationFeedbackGenerator()
    
    // MARK: Create Views
    let profileImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "exeLogo_black")
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.InterfaceColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let logInRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.InterfaceColor.black.withAlphaComponent(0.5)
        button.setTitle("R E G I S T E R", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleTouchDown() {
        // Feedback
        hapticImpactLight.impactOccurred()
        
//        // Animation
//        UIView.animate(withDuration: 0.1, animations: {
//            self.logInRegisterButton.backgroundColor = self.logInRegisterButton.backgroundColor?.withAlphaComponent(0.5)
//            self.logInRegisterButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.98)
//        })
    }

    @objc func handleRegister() {
        // Feedback
        hapticImpactLight.impactOccurred()
        
        //        // Animation
        //        UIView.animate(withDuration: 0.13, animations: {
        //            self.logInRegisterButton.backgroundColor = self.logInRegisterButton.backgroundColor?.withAlphaComponent(0.3)
        //            self.logInRegisterButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        //        })
        
        // MARK: Registration
        if (inputInfoValidation()) {
            
            Alamofire.request(KeyCenter.RegisterUrl + telTextField.text!)
                .responseJSON { response in
//                    debugPrint(response)
                    // Get status code
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200:
                            print("Registration \(response.result)")
                        default:
                            print("error with response status: \(status)")
                        }
                    }
                    
                    // MARK: Get salt from response
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
                        guard let content = JSON["content"] as? [String: Any],
                            let salt = content["salt"] as? String else {
                                print("Failed to parse JSON")
                                return
                        }
                        self.salt = salt
                        print("salt from Server: \(self.salt)")
                        self.hashSaltAndPassw()
                    }
            }
            
            // Transition to mainPageVC
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainPageVC") as! ViewController
            self.present(newViewController, animated: true, completion: nil)
            
        } else {
            // Validation
            print("Input Validation FAILED.\nPlease recheck your input and try again.")
        }
        
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.InterfaceColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let telTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Number"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let telSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.InterfaceColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.InterfaceColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.InterfaceColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var passwVeriTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.InterfaceColor.naviBlue
        
        view.addSubview(inputsContainerView)
        view.addSubview(logInRegisterButton)
        view.addSubview(profileImgView)
        
        setupInputsContainerView()
        setupLogInRegisterButton()
        setupProfileImgView()
        
        nameTextField.delegate      = self
        telTextField.delegate       = self
        emailTextField.delegate     = self
        passwTextField.delegate     = self
        passwVeriTextField.delegate = self
        
//        // for AutoFill feature
//        if #available(iOS 11.0, *) {
//            emailTextField.textContentType = .username
//            passwTextField.textContentType = .password
//        } else {
//            // Fallback on earlier versions
//        }
        
        // Setup keyboardtype for each TF
        nameTextField.keyboardType  = .default
        telTextField.keyboardType   = .numberPad
        emailTextField.keyboardType = .emailAddress
        // Setup "return" key on keyboard for each TF
        nameTextField.returnKeyType  = UIReturnKeyType.next
        telTextField.returnKeyType   = UIReturnKeyType.next
        emailTextField.returnKeyType = UIReturnKeyType.next
        passwTextField.returnKeyType = UIReturnKeyType.next
        // Dismiss Keyboard using "return" key on keyboard.
        passwVeriTextField.returnKeyType = UIReturnKeyType.done // Last input TF should be here!!!
        
        // Enable Tap elsewhere to dismissKeyboard func
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tapToDismissKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismissKeyboard)
        
    }
    
    // MARK: - Functions
    // MARK: Registration info Encryption
    func hashSaltAndPassw() {
        let passw: Array<UInt8> = Array(passwTextField.text!.utf8)
        let salt: Array<UInt8> = Array(self.salt.utf8)
        let key = try! HKDF(password: passw, salt: salt, variant: .md5).calculate()
        var digestHex = ""
        for index in 0..<Int(key.count) {
            digestHex += String(format: "%02x", key[index])
        }
        print(self.passwTextField.text!)
        print(passw)
        print(key.count)
        print(key)
        print(digestHex)
    }
    
    // MARK: Input info Validation
    func inputInfoValidation() -> Bool {
        if (telTextField.text!.isValidTel() && emailTextField.text!.isValidEmail() && passwTextField.text!.isValidPassword() && passwTextField.text == passwVeriTextField.text) {
            return true
        } else {
            print("telValidation: \(telTextField.text!.isValidTel())")
            print("emailValidation: \(emailTextField.text!.isValidEmail())")
            print("passwValidation: \(passwTextField.text!.isValidPassword())")
            print("passwVerification: \(passwTextField.text == passwVeriTextField.text)")
        }
        return false
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameTextField:
                telTextField.becomeFirstResponder()
            case telTextField:
                emailTextField.becomeFirstResponder()
            case emailTextField:
                passwTextField.becomeFirstResponder()
            case passwTextField:
                passwVeriTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        telTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwTextField.resignFirstResponder()
        passwVeriTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupProfileImgView() {
        //Constraints
        profileImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImgView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -60).isActive = true
        profileImgView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -100).isActive = true
//        profileImgView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        profileImgView.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
//        profileImgView.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
//        profileImgView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupInputsContainerView() {
        //Constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        //Input Fields
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(telTextField)
        inputsContainerView.addSubview(telSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwTextField)
        inputsContainerView.addSubview(passwSeparatorView)
        inputsContainerView.addSubview(passwVeriTextField)
        
        //Constraints for nameTextField
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        //Constraints for nameSeparatorView
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -1).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for telTextField
        telTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        telTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        telTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        telTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        //Constraints for telSeparatorView
        telSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        telSeparatorView.topAnchor.constraint(equalTo: telTextField.bottomAnchor, constant: -1).isActive = true
        telSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        telSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for emailTextField
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        emailTextField.topAnchor.constraint(equalTo: telSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        //Constraints for emailSeparatorView
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -1).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for passwTextField
        passwTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        passwTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        //Constraints for passwSeparatorView
        passwSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwSeparatorView.topAnchor.constraint(equalTo: passwTextField.bottomAnchor, constant: -1).isActive = true
        passwSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        passwSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for passwVeriTextField
        passwVeriTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwVeriTextField.topAnchor.constraint(equalTo: passwSeparatorView.bottomAnchor).isActive = true
        passwVeriTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        passwVeriTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupLogInRegisterButton() {
        //Constraints
        logInRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 48).isActive = true
        logInRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        logInRegisterButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: - Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

// MARK: - Validation
extension String {
    
    func isValidEmail() -> Bool {
        let emailRegex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return emailRegex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z]).{6,24}$" // at lease one UPPER CASE LETTER and one lower case letter
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidTel() -> Bool {
        let telRegex = "^1[0-9]{10}$" // 11 digits starting with "1"
        if NSPredicate(format: "SELF MATCHES %@", telRegex).evaluate(with: self) {
            return true
        }
        return false
    }
    
/*
     // At least one upper case letter, one special character, one digit, one lower case letter, Password length must be equal to or greater than 8.
     "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
*/

}
