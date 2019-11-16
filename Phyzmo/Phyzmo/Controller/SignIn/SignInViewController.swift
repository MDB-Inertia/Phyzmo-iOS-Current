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
            if error != nil || user == nil{
                self.displayAlert(type : "nil" , title: "Incorrect Login", message : "The login details you entered is incorrect. Please try again." )
            }
            else if !Auth.auth().currentUser!.isEmailVerified{
                self.displayAlert(type: "Verification" , title: "Verification", message : "Please Verify Your Email." )
            }
            else{
                let currentID = Auth.auth().currentUser!.uid
                UserDefaults.standard.set(currentID, forKey: "user")
                print(currentID)
                self.performSegue(withIdentifier: "SignInToMain", sender: self)
            }
        }
    }
            
            
            
    func displayAlert(type: String, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch type{
        case "Verification":
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let resendVerification = UIAlertAction(title: "Resend Verfication Email", style: .default, handler: { action in
                self.sendVerificationMail()
                
            })
            alert.addAction(defaultAction)
            alert.addAction(resendVerification)
            self.present(alert, animated: true, completion: nil)
        default:
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func sendVerificationMail(){
        Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
            self.displayAlert(type: "nil", title: "Verification", message : "Verification Email Send" )
            })
    }
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        handleSignIn()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SignInToSignUp", sender: self)
    }
    
}
