//
//  ViewController.swift
//  SampleProj
//
//  Created by SUBRAT on 3/17/18.
//  Copyright © 2018 Olive Crypto Systems LLP. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin

class ViewController: UIViewController {
    
    var dict : [String : AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func loginButnCicked(_ sender: Any) {    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, name, picture.type(large), id, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    self.dict = result as! [String : AnyObject]
                let cntrl = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                    cntrl.dictReceived = result
                    cntrl.dict = self.dict
                    self.navigationController?.pushViewController(cntrl, animated: true)
                }
            })
        }
    }
    
}

