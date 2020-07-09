//
//  LoginFormController.swift
//  Weather
//
//  Created by Matthew on 13.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var loadingIndicator: LoadingIndicator!
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard checkUserCredentials() else {
            showSigninErrorMessage()
            return false
        }
        return true
    }
    
    func checkUserCredentials() -> Bool{
         return loginTextField.text == "user" && passwordTexField.text == "123"
    }
    
    func showSigninErrorMessage() {
        let alter = UIAlertController(title: "Error", message: "Wrong credentials", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
         NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    @IBAction func LogInClick(_ sender: Any) {
        guard checkUserCredentials() else {
            showSigninErrorMessage()
            return
        }
        stackView.isHidden = true
        loadingIndicator.isHidden = false
        
        perform(#selector(successLogin), with: nil, afterDelay: 0.5)
        
    }
    
    @objc private func successLogin(){
        performSegue(withIdentifier: "SuccesLoginSegue", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
    }
    
    @objc func keyboardWillHide(notification: Notification){
        scrollView.contentInset = .zero
    }
    
    @IBAction func scrollTapped(_ sender: UITapGestureRecognizer) {
        //print(#function)
        scrollView.endEditing(true)
    }
    
}
