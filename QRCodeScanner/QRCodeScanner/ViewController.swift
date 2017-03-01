//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by Rodrigo Morbach on 27/02/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, QRCodeScannerProtocol {

    let qrCodeManager = QRCodeManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func readQRCode(_ sender: UIButton) {
        qrCodeManager.readQRCode(previewView: self.view, delegate: self)
    }
    
    //MARK: QRCodeScannerProtocol methods
    func didFail(qrCode: Any?, error: Error) {
        self.qrCodeManager.stopReading()
    }
    func didFinishReading(qrCode: Any?, content: String) {
        print("Read value from QRCode \(content)")
        self.qrCodeManager.stopReading()
        if content.hasPrefix("http")
        {
            let openURLAction = UIAlertAction(title: "Open URL", style: .default, handler: { alert in
                guard let url = URL(string: content) else
                {
                    return
                }
                UIApplication.shared.openURL(url)
            })
            
            let dismissAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: { alert in
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            
            AlertHelper.showConfirm(title: "URL", message: "Wish to open \(content) ?", actions: [dismissAction, openURLAction], fromViewController: self)
            
        }else
        {
            AlertHelper.showAlert(title: "Content", message: content, dismissTitle: "OK", fromViewController: self)
        }
    }
}

