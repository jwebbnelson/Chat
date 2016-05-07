//
//  LoginViewController.swift
//  Chat
//
//  Created by Soren Nelson on 4/29/16.
//  Copyright © 2016 SORN. All rights reserved.
//

import UIKit
import CloudKit

class LoginViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        self.iCloudLogin { (success) in
            if success {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                print("Noice Job Mate!")
                print(UserController.sharedInstance.currentUser?.firstName)
            } else {
                print("Not this time")
            }
        }
    }
    
    func iCloudLogin(completion:(success: Bool) -> Void) {
        UserController.sharedInstance.requestPermission { (success) in
            if success {
                UserController.sharedInstance.fetchUser({ (success, user) in
                    if success {
                        UserController.sharedInstance.fetchUserInfo(user!, completion: { (success, user) in
                            if success {
                                UserController.sharedInstance.currentUser = user!
                                completion(success: true)
                            }
                        })
                    } else {
//                        error handling
                        print("Didn't Work")
                    }
                })
            } else {
                let iCloudAlert = UIAlertController(title: "iCloud Error", message: "Error connecting to iCloud. Check iCloud settings by going to Settings > iCloud.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                iCloudAlert.addAction(ok)
                self.presentViewController(iCloudAlert, animated: true, completion: nil)
            }
        }
    }

    
}
