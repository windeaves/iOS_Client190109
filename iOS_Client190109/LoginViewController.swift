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
            // Disable User Interaction
            view.isUserInteractionEnabled = false
            
            let register1Request = KeyCenter.Register1Url + telTextField.text!
            Alamofire.request(register1Request)
                .responseJSON { response in
//                    debugPrint(response)
//                    // Get status code
//                    if let status = response.response?.statusCode {
//                        switch(status){
//                        case 200:
//                            print("Registration \(response.result)")
//                        default:
//                            print("error with response status: \(status)")
//                        }
//                    }
                    
                    // MARK: Get salt from response
                    if let result = response.result.value {
                        let responseJSON = result as! NSDictionary
//                        print(responseJSON)
                        guard let content = responseJSON["content"] as? [String: Any],
                            let salt = content["salt"] as? String else {
                                print("Parsing JSON FAILED")
                                return
                        }
                        self.salt = salt
                        print("salt from Server: \(self.salt)")
                        self.hashSaltAndPassw()
                        let register2Part1 = KeyCenter.Register2Url + "?tel=" + self.telTextField.text!
                        let register2Request = register2Part1 + "mail=" + self.emailTextField.text! + "passsalt=" + self.hashed
                        print(register2Request)
                        Alamofire.request(register2Request).response { response in
                            debugPrint(response)
                        }
                    }
            }
            
//            // Transition to mainPageVC
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainPageVC") as! ViewController
//            self.present(newViewController, animated: true, completion: nil)
        } else {
            // Validation
            print("Input Validation FAILED.\nPlease recheck your input and try again.")
        }
        
    }
    
//    let nameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Your Name"
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
    
//    let nameSeparatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.InterfaceColor.lightGray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.InterfaceColor.naviBlue
        
        view.addSubview(inputsContainerView)
        view.addSubview(logInRegisterButton)
        view.addSubview(profileImgView)
        
        setupInputsContainerView()
        setupLogInRegisterButton()
        setupProfileImgView()
        
//        nameTextField.delegate      = self
        telTextField.delegate       = self
        emailTextField.delegate     = self
        passwTextField.delegate     = self
        passwVeriTextField.delegate = self
        
        // Setup keyboardtype for each TF
//        nameTextField.keyboardType  = .default
        telTextField.keyboardType   = .numberPad
        emailTextField.keyboardType = .emailAddress
        // Setup "return" key on keyboard for each TF
//        nameTextField.returnKeyType  = UIReturnKeyType.next
        telTextField.returnKeyType   = UIReturnKeyType.next
        emailTextField.returnKeyType = UIReturnKeyType.next
        passwTextField.returnKeyType = UIReturnKeyType.next
        // Dismiss Keyboard using "return" key on keyboard.
        passwVeriTextField.returnKeyType = UIReturnKeyType.done // Last input TF should be here!!!
        
        // MARK: Keyboard related
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // Enable Tap elsewhere to dismissKeyboard func
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tapToDismissKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismissKeyboard)
        
    }
    
//    deinit {
//        // Stop listening to Keyboard events
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
    
//    @objc func keyboardWillChange(notification:  Notification) {
//        if notification.name == UIResponder.keyboardWillShowNotification ||
//            notification.name == UIResponder.keyboardWillChangeFrameNotification {
//            inputsContainerView.frame.origin.y += -10
//        } else {
//            inputsContainerView.frame.origin.y += -10
//        }
//    }
    
    // MARK: - Functions
    // MARK: Registration info Encryption
    func hashSaltAndPassw() {
        let passwWithSalt = self.passwTextField.text! + salt
        print("Passw+salt: \(passwWithSalt)")
        hashed = passwWithSalt.md5()
        print("hashed: \(hashed)")
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
//        nameTextField.resignFirstResponder()
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
        profileImgView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -82).isActive = true
        profileImgView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -118).isActive = true
    }
    
    func setupInputsContainerView() {
        //Constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -36).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //Input Fields
//        inputsContainerView.addSubview(nameTextField)
//        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(telTextField)
        inputsContainerView.addSubview(telSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwTextField)
        inputsContainerView.addSubview(passwSeparatorView)
        inputsContainerView.addSubview(passwVeriTextField)
        
//        //Constraints for nameTextField
//        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
//        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
//        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
//        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
//
//        //Constraints for nameSeparatorView
//        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
//        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -1).isActive = true
//        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
//        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for telTextField
        telTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        telTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        telTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        telTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        //Constraints for telSeparatorView
        telSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        telSeparatorView.topAnchor.constraint(equalTo: telTextField.bottomAnchor, constant: -1).isActive = true
        telSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        telSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for emailTextField
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        emailTextField.topAnchor.constraint(equalTo: telSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        //Constraints for emailSeparatorView
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -1).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for passwTextField
        passwTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        passwTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        //Constraints for passwSeparatorView
        passwSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwSeparatorView.topAnchor.constraint(equalTo: passwTextField.bottomAnchor, constant: -1).isActive = true
        passwSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        passwSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for passwVeriTextField
        passwVeriTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwVeriTextField.topAnchor.constraint(equalTo: passwSeparatorView.bottomAnchor).isActive = true
        passwVeriTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        passwVeriTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    func setupLogInRegisterButton() {
        //Constraints
        logInRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 68).isActive = true
        logInRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        logInRegisterButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    // MARK: - VC Settings
    // MARK: Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    // MARK: Rotation Disabled
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // Only allow Portrait
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
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
