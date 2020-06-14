//
//  LoginFormController.swift
//  Weather
//
//  Created by Matthew on 13.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    
    @IBAction func signinPressed(_ sender: Any) {
        if loginTextField.text == "admin" && passwordTexField.text == "admin"{
            print("Success login")
        }else{
            print("Fail login")
        }
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
        print(#function)
        scrollView.endEditing(true)
    }
    
}
