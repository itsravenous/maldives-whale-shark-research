//
//  SignInViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/2/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import ILLoginKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignInViewController: UIViewController {

    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
       
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "signedIn") {
            showLogin()
        } else if (FBSDKAccessToken.current() != nil) {
            print("User has a FB login token - SIGN IN")
            performSegue(withIdentifier: "signInSegue", sender: nil)
        } else {
            print("SIGN IN")
            performSegue(withIdentifier: "signInSegue", sender: nil)
        }
        
    }
    
    func showLogin() {
        loginCoordinator.start()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
