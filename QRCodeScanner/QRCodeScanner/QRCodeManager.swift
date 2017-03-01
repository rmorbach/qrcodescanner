//
//  QRCodeManager.swift
//  QRCodeScanner
//
//  Created by Rodrigo Morbach on 27/02/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import UIKit
import AVFoundation

//Camera Errors
enum CameraError: Error
{
    case setup;
    case invalidPreview;
    case unknown;
}

class QRCodeManager: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    static let sharedManager = QRCodeManager()
    
    var captureSession: AVCaptureSession?
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var delegate: QRCodeScannerProtocol?
    
    override init() {
        super.init()
        setupCamera()
        createQRCodeView()
    }
    
    open func readQRCode(previewView: UIView, delegate: QRCodeScannerProtocol)
    {
        self.delegate = delegate
        
        //Preview
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: previewView.frame.width, height: previewView.frame.height)
        
        previewView.layer.addSublayer(self.videoPreviewLayer!)
        
        previewView.addSubview(self.qrCodeFrameView!)
        previewView.bringSubview(toFront: self.qrCodeFrameView!)
        
        self.captureSession?.startRunning()
    }
    
    func setupCamera()
    {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice);
            self.captureSession = AVCaptureSession()
            self.captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput();
            self.captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
        }catch
        {
            print("error")
            self.delegate?.didFail(qrCode: nil, error:CameraError.setup)
            return
        }

    }
    
    open func stopReading()
    {
        if self.captureSession != nil && self.captureSession!.isRunning
        {
            self.videoPreviewLayer?.removeFromSuperlayer()
            self.captureSession?.stopRunning();
            self.qrCodeFrameView?.removeFromSuperview()
        }
    }
    
    func createQRCodeView()
    {
        self.qrCodeFrameView = UIView()
        self.qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor;
        self.qrCodeFrameView?.layer.borderWidth = 8.0
        
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0
        {
            self.qrCodeFrameView?.frame = CGRect.zero;
            return
        }
        
        
        if let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
        {
            if metadataObject.type == AVMetadataObjectTypeQRCode
            {
                let barCodeObject = self.videoPreviewLayer?.transformedMetadataObject(for: metadataObject)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                if metadataObject.stringValue != nil
                {                    
                    self.delegate?.didFinishReading(qrCode: nil, content: metadataObject.stringValue)
                }
            }                        
        }
    }
}
