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
    
    let profileImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "Log_pic.jpg")
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    let logInRegisterButton: UIButton = {
        let button = UIButton(type:.system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("R E G I S T E R", for:.normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRegister() {
        //Just for Testing
        telNum = telTextField.text ?? ""
        print(KeyCenter.RegisterUrl + telNum)
        
        Alamofire.request(KeyCenter.RegisterUrl + telNum)
            .responseJSON { response in
                debugPrint(response)
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainPageVC") as! ViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let telTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Telephone Number"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let telSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var passwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(logInRegisterButton)
        view.addSubview(profileImgView)
        
        setupInputsContainerView()
        setupLogInRegisterButton()
        setupProfileImgView()
        
        // MARK: - Setup "return" key on keyboard for each TF
        nameTextField.delegate = self
        telTextField.delegate = self
        passwTextField.delegate = self
        nameTextField.returnKeyType = UIReturnKeyType.next
        telTextField.returnKeyType = UIReturnKeyType.next
        // Dismiss Keyboard using "return" key on keyboard.
        passwTextField.returnKeyType = UIReturnKeyType.done // Last input TF should be here!!!
        
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
                passwTextField.resignFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        telTextField.resignFirstResponder()
        passwTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupProfileImgView() {
        //Constraints
        profileImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImgView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profileImgView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImgView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupInputsContainerView() {
        //Constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //Input Fields
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(telTextField)
        inputsContainerView.addSubview(telSeparatorView)
        inputsContainerView.addSubview(passwTextField)
        
        //Constraints for nameTextField
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //Constraints for nameSeparatorView
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -20).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for telTextField
        telTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        telTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        telTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        telTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //Constraints for emailSeparatorView
        telSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 10).isActive = true
        telSeparatorView.topAnchor.constraint(equalTo: telTextField.bottomAnchor).isActive = true
        telSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -20).isActive = true
        telSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints for passwTextField
        passwTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
        passwTextField.topAnchor.constraint(equalTo: telSeparatorView.bottomAnchor).isActive = true
        passwTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupLogInRegisterButton() {
        //Constraints
        logInRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 24).isActive = true
        logInRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        logInRegisterButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    //Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
