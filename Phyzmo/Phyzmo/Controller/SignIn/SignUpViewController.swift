//
//  SignUpViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    //UI Elements
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor, UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor
        ]
        layer.shouldRasterize = true
        //layer.startPoint = CGPoint(x: 0,y: 0.5)
        //layer.startPoint = CGPoint(x: 1,y: 1)
        backgroundView.layer.addSublayer(layer)
        

    }
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(SignInViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
    func handleSignUp(){
        guard let fullname = fullNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password){ user, error in
            if error == nil && user != nil {
                print("User created")
                let currentID = Auth.auth().currentUser!.uid
                let db = Database.database().reference()
                let usersNode = db.child("Users")
                let userNode = usersNode.child(currentID)
                userNode.updateChildValues(["fullname": fullname, "email": email])
                UserDefaults.standard.set(currentID, forKey: "user")
                self.sendVerificationMail()
                //self.dismiss(animated: false, completion: nil)
            }
            else {
                self.displayAlert(title: "Error", message : "Error creating user. Please try again." )
            }
        }
         
        
    }
    

    func sendVerificationMail(){
        Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
            self.displayAlert(title: "Verification", message : "Error Sending Verification Email. Please try again." )
            })
        self.displayAlert(title: "Verification", message : "Verification Email Send" )
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        handleSignUp()
    }
    
    
}


