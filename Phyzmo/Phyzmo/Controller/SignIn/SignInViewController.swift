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
    @IBOutlet weak var backgroundView: UIView!
    
    //Variables
    var userEmail : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor, UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor
        ]
        layer.shouldRasterize = true
        //layer.startPoint = CGPoint(x: 0,y: 0.5)
        //layer.startPoint = CGPoint(x: 1,y: 1)
        backgroundView.layer.addSublayer(layer)
        
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
