//
//  AppDelegate.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkAccountStatus { (success) in
            let fetchedUserStatement = success ? "Successfully retrieved an account" : "There was an issue retreiving an account"
            print(fetchedUserStatement)
        }
        return true
    }
    
    func checkAccountStatus(completion: @escaping (Bool) -> Void) {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            } else {
                DispatchQueue.main.async {
                    let rootViewController = self.window?.rootViewController
                    let errorTitle = "Please check your iCloud account in the Settings App of your Device"
                    switch status {
                    case .available:
                        completion(true)
                    case .couldNotDetermine:
                        rootViewController?.presentSimpleAlertWith(title: errorTitle, message:"Could not determine the status of your account" )
                        completion(false)
                    case .noAccount:
                        rootViewController?.presentSimpleAlertWith(title: errorTitle, message: "No iCloud account was found")
                        completion(false)
                    case .restricted:
                        rootViewController?.presentSimpleAlertWith(title: errorTitle, message: "Your iCloud account is restricted")
                        completion(false)
                    default:
                        completion(false)
                    }
                }
            }
        }
    }
}// End of Class
