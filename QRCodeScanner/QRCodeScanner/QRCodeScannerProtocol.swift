//
//  QRCodeScannerProtocol.swift
//  QRCodeScanner
//
//  Created by Rodrigo Morbach on 27/02/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import Foundation

//Errors generated from QRCode
enum QRCodeError:Error
{
    case invalidQRCode;
    case unknow;
}

protocol QRCodeScannerProtocol {
    
    func didFinishReading(qrCode: Any?, content:String)->Void;
    func didFail(qrCode: Any?, error: Error);
}
