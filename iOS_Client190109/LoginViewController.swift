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
import FRHyperLabel

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var salt:   String = ""
    var hashed: String = ""
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // MARK: Setup Haptic Feedback
    let hapticImpactLight  = UIImpactFeedbackGenerator(style: .light)
    let hapticImpactMedium = UIImpactFeedbackGenerator(style: .medium)
    let hapticImpactHeavy  = UIImpactFeedbackGenerator(style: .heavy)
    let hapticSelection    = UISelectionFeedbackGenerator()
    let hapticNotification = UINotificationFeedbackGenerator()
    
    @IBOutlet weak var signNoteLb: FRHyperLabel!
    
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
    
    let signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.InterfaceColor.black.withAlphaComponent(0.5)
        button.setTitle("R E G I S T E R", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
//        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleTouchDown() {
        // Feedback
        hapticImpactLight.impactOccurred()
    }

    @objc func handleSignUp() {
        // Feedback
        hapticImpactLight.impactOccurred()
        
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
    
    let signInBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.InterfaceColor.black.withAlphaComponent(0.5)
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
//        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        button.isHidden = true
        
        return button
    }()
    
    @objc func handleSignIn() {
        // MARK: - SignIn Process
        
    }
    
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
        
        view.backgroundColor = UIColor.InterfaceColor.TianyiBlue
        
        view.addSubview(inputsContainerView)
        view.addSubview(signUpBtn)
        view.addSubview(profileImgView)
        view.addSubview(signNoteLb)
        
        setupInputsContainerView()
        setupLogInRegisterButton()
        setupProfileImgView()
        setupSignNoteLb()
        
//        nameTextField.delegate      = self
        telTextField.delegate       = self
        emailTextField.delegate     = self
        passwTextField.delegate     = self
        passwVeriTextField.delegate = self
        
        // Setup keyboardtype for each TF
        telTextField.keyboardType   = .numberPad
        emailTextField.keyboardType = .emailAddress
        // Setup "return" key on keyboard for each TF
        telTextField.returnKeyType   = UIReturnKeyType.next
        emailTextField.returnKeyType = UIReturnKeyType.next
        passwTextField.returnKeyType = UIReturnKeyType.next
        // Dismiss Keyboard using "return" key on keyboard.
        passwVeriTextField.returnKeyType = UIReturnKeyType.done // Last input TF should be here!!!
        
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tapToDismissKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismissKeyboard)
        
    }
    
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
        if screenHeight == 568.0 && screenWidth == 320.0 {
            // iPhone with 4 inch Screen
            profileImgView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -56).isActive = true
            profileImgView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -90).isActive = true
        } else {
            // iPhone with >= 4.7 inch Screen
            profileImgView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -78).isActive = true
            profileImgView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -114).isActive = true
        }
    }
    
    func setupInputsContainerView() {
        //Constraints
        if screenHeight == 568.0 && screenWidth == 320.0 {
            // iPhone with 4 inch Screen
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        } else {
            // iPhone with >= 4.7 inch Screen
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -36).isActive = true
        }
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //Input Fields
        inputsContainerView.addSubview(telTextField)
        inputsContainerView.addSubview(telSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwTextField)
        inputsContainerView.addSubview(passwSeparatorView)
        inputsContainerView.addSubview(passwVeriTextField)
        
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
        if screenHeight == 568.0 && screenWidth == 320.0 {
            // iPhone with 4 inch Screen
            signUpBtn.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 48).isActive = true
            signUpBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        } else {
            // iPhone with >= 4.7 inch Screen
            signUpBtn.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 68).isActive = true
            signUpBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        }
        signUpBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpBtn.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
    }
    
    func setupSignNoteLb() {
        let string = "Already have account? Sign in here!"
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        signNoteLb.attributedText = NSAttributedString(string: string, attributes: attributes)
        let handler = {
            (hyperLabel: FRHyperLabel!, substring: String!) -> Void in
            self.setupSignInView()
        }
        signNoteLb.setLinksForSubstrings(["Sign in here!"], withLinkHandler: handler)
    }
    
    // MARK: - Setup SignIn View
    func  setupSignInView() {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.inputsContainerView.alpha = 0
        }, completion: { _ in
            self.inputsContainerView.isHidden = true
            // New inputContainerView
            // Show signInBtn
            // Change signNoteLb.text
            self.view.isUserInteractionEnabled = true
        })
        
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
