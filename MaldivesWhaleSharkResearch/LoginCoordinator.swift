//
//  LoginCoordinator.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/3/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import Foundation
import ILLoginKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit

class LoginCoordinator: ILLoginKit.LoginCoordinator {
    
    // MARK: - LoginCoordinator
    
    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
        
    // MARK: - Setup
    
    func configureAppearance() {
        // Customize LoginKit. All properties have defaults, only set the ones you want.
        
        // Customize the look with background & logo images
        backgroundImage = #imageLiteral(resourceName: "LoginScreen")
        // mainLogoImage = #imageLiteral(resourceName: "mwsrpLogo")
        // secondaryLogoImage = #imageLiteral(resourceName: "smallLogo")
        
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password!"
        repeatPasswordPlaceholder = "Confirm password!"
    }
    
    // MARK: - Completion Callbacks
    
    override func login(email: String, password: String) {
        // Handle login via your API
        print("Login with: email =\(email) password = \(password)")
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            print("Sign in attempted...")
            if error != nil {
                print("HOLA UN ERROR:\(error)")
            } else {
                print("Signed in successfully")
                let userDefaults = UserDefaults.standard
                
                if !userDefaults.bool(forKey: "signedIn") {
                    userDefaults.set(true, forKey: "signedIn")
                    userDefaults.synchronize()
                }
                super.finish()
                
            }
        })
    }
    
    override func signup(name: String, email: String, password: String) {
        // Handle signup via your API
        print("Signup with: name = \(name) email =\(email) password = \(password)")
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            print("Tried to create a user...")
            if error != nil {
                print("HOLA UN ERROR:\(error)")
            } else {
                print("Created user successfully")
                Database.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                
                let userDefaults = UserDefaults.standard
                
                if !userDefaults.bool(forKey: "signedIn") {
                    userDefaults.set(true, forKey: "signedIn")
                    userDefaults.synchronize()
                }
                super.finish()
            }
        })
    }
    
    override func enterWithFacebook(profile: FacebookProfile) {
        // Handle Facebook login/signup via your API
        print("Login/Signup via Facebook with: FB profile =\(profile)")
        if (FBSDKAccessToken.current() != nil) {
            let userDefaults = UserDefaults.standard
            
            if !userDefaults.bool(forKey: "signedIn") {
                userDefaults.set(true, forKey: "signedIn")
                userDefaults.synchronize()
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    return
                }
            })
            
            super.finish()
        }
        
    }
    
    override func recoverPassword(email: String) {
        // Handle password recovery via your API
        print("Recover password with: email =\(email)")
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                print("An email with information on how to reset your password has been sent")
                super.finish()
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
}
