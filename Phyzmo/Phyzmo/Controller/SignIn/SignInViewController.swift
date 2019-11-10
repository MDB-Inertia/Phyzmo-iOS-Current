//
//  SignInViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import Firebase



class SignInViewController: UIViewController {
    
    //UI Elements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    //Variables
    var userEmail : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "SignInToMain", sender: self)
        }
    }
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(SignInViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
    func handleSignIn() {
        guard let userEmail = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: userEmail, password: password) { user, error in
            if error  == nil && user != nil{
                let currentID = Auth.auth().currentUser!.uid
                UserDefaults.standard.set(currentID, forKey: "user")
                print(currentID)
                self.performSegue(withIdentifier: "SignInToMain", sender: self)
            }
        }
    }
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        handleSignIn()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SignInToSignUp", sender: self)
    }
    
}
