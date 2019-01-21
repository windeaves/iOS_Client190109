//
//  LoginViewController.swift
//  iOS_Client190109
//
//  Created by 唐子轩 on 2019/1/11.
//  Copyright © 2019 TonyTang. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var telNum: String = ""
    
    //MARK: Setup Haptic Feedback
    let hapticImpactLight  = UIImpactFeedbackGenerator(style: .light)
    let hapticImpactMedium = UIImpactFeedbackGenerator(style: .medium)
    let hapticImpactHeavy  = UIImpactFeedbackGenerator(style: .heavy)
    let hapticSelection    = UISelectionFeedbackGenerator()
    let hapticNotification = UINotificationFeedbackGenerator()
    
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
        
        // Registration func
        telNum = telTextField.text ?? ""
//        Alamofire.request(KeyCenter.RegisterUrl + telNum)
//            .responseJSON { response in
//                debugPrint(response)
//                print("Registration Status: \(response.result)")
//        }
        
        // Present mainPageVC
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainPageVC") as! ViewController
        self.present(newViewController, animated: true, completion: nil)
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
        
        view.backgroundColor = UIColor.InterfaceColor.TianyiBlue
        
        view.addSubview(inputsContainerView)
        view.addSubview(logInRegisterButton)
        view.addSubview(profileImgView)
        
        setupInputsContainerView()
        setupLogInRegisterButton()
        setupProfileImgView()
        
        nameTextField.delegate      = self
        telTextField.delegate       = self
        passwTextField.delegate     = self
        passwVeriTextField.delegate = self
        // Setup keyboardtype for each TF
        nameTextField.keyboardType = .default
        telTextField.keyboardType  = .numberPad
        // Setup "return" key on keyboard for each TF
        nameTextField.returnKeyType  = UIReturnKeyType.next
        telTextField.returnKeyType   = UIReturnKeyType.next
        passwTextField.returnKeyType = UIReturnKeyType.next
        // Dismiss Keyboard using "return" key on keyboard.
        passwVeriTextField.returnKeyType = UIReturnKeyType.done // Last input TF should be here!!!
        
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tapToDismissKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismissKeyboard)
        
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameTextField:
                telTextField.becomeFirstResponder()
            case telTextField:
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
        passwTextField.resignFirstResponder()
        passwVeriTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //Functions
    func isValidPassword(testPwd: String?) -> Bool{
        guard testPwd != nil else {
            return false
        }
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$")
        return passwordPred.evaluate(with: testPwd)
    }
    
    func setupProfileImgView() {
        //Constraints
        profileImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImgView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -80).isActive = true
        profileImgView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -120).isActive = true
//        profileImgView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        profileImgView.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
//        profileImgView.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
//        profileImgView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupInputsContainerView() {
        //Constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -24).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //Input Fields
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(telTextField)
        inputsContainerView.addSubview(telSeparatorView)
        inputsContainerView.addSubview(passwTextField)
        inputsContainerView.addSubview(passwSeparatorView)
        inputsContainerView.addSubview(passwVeriTextField)
        
        //Constraints for nameTextField
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        //Constraints for nameSeparatorView
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -1).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for telTextField
        telTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        telTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        telTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        telTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4, constant: -1).isActive = true
        
        //Constraints for emailSeparatorView
        telSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        telSeparatorView.topAnchor.constraint(equalTo: telTextField.bottomAnchor).isActive = true
        telSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        telSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for passwTextField
        passwTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwTextField.topAnchor.constraint(equalTo: telSeparatorView.bottomAnchor).isActive = true
        passwTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4, constant: -1).isActive = true
        
        //Constraints for passwSeparatorView
        passwSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwSeparatorView.topAnchor.constraint(equalTo: passwTextField.bottomAnchor).isActive = true
        passwSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -32).isActive = true
        passwSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for passwVeriTextField
        passwVeriTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwVeriTextField.topAnchor.constraint(equalTo: passwSeparatorView.bottomAnchor).isActive = true
        passwVeriTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwVeriTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4, constant: -1).isActive = true
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

//extension UIColor {
//    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
//        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
//    }
//}
