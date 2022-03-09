//
//  ViewController.swift
//  BioAuth
//
//  Created by Mariana Steblii on 08/03/2022.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context.localizedCancelTitle = "End session"
        context.localizedFallbackTitle = "Use password"
        context.localizedReason = "The app needs your authentication"
        // if user use touchID user do not need reauthenticate again during the time you choose
        context.touchIDAuthenticationAllowableReuseDuration = LATouchIDAuthenticationMaximumAllowableReuseDuration // max time allowed -  5 min
        evaluatePolicy()
    }

    func evaluatePolicy() {
        var errorCanEval: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &errorCanEval) {
            
            switch context.biometryType {
            case .faceID:
                print("Face ID")
            case .touchID:
                print("Touch ID")
            case .none:
                print("None")
            @unknown default:
                print("unknown")
            }
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Fallback title - override reason") { success, error in
                print(success)
                if let err = error {
                    let evalErrCode = LAError(_nsError: err as NSError)
                    switch evalErrCode.code {
                    case LAError.Code.userCancel:
                        print("user cancelled")
                    case LAError.Code.userFallback:
                        print("fallback")
                    case LAError.Code.authenticationFailed:
                        print("failed")
                    default:
                        print("other error")
                    }
                }
            }
        } else {
            print("can't evaluate")
            print(errorCanEval?.localizedDescription ?? "no error desc")
        }
    }
}

