//
//  AlertHelper.swift
//  QRCodeScanner
//
//  Created by Rodrigo Morbach on 28/02/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {

    
    private class func createAlert(title: String, message: String)->UIAlertController
    {
        return UIAlertController(title: title, message: message, preferredStyle: .alert);
    }
    
    open class func showAlert(title: String, message: String, dismissTitle: String, fromViewController: UIViewController)->Void
    {
        let alert = AlertHelper.createAlert(title: title, message: message)
        let dismissAction = UIAlertAction(title: dismissTitle, style: .cancel) { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(dismissAction)
        fromViewController.show(alert, sender: nil)
    }
    
    open class func showConfirm(title: String, message: String, actions: [UIAlertAction], fromViewController: UIViewController)->Void
    {
        let alert = AlertHelper.createAlert(title: title, message: message)
        for action in actions
        {
            alert.addAction(action)
        }
        fromViewController.show(alert, sender: nil)
    }
    
    
}
