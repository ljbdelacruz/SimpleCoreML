//
//  ScanningViewController.swift
//  SimpleAIVideoRecognition
//
//  Created by Lainel John Dela Cruz on 11/11/2018.
//  Copyright © 2018 Lainel John Dela Cruz. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision


class ScanningViewController: UIViewController {
    @IBOutlet weak var UIVideoDisplay: PreviewView!
    @IBOutlet weak var UIItemDescription: UILabel!
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "Camera Session Queue", attributes: [], target: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: permission func
extension ScanningViewController{
    private func checkPermission(completionHandler: @escaping (Bool) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            completionHandler(true);
        case .notDetermined:
            self.requestPermission(completionHandler: {
                (isGranted) in
                completionHandler(isGranted);
            })
        default:
            completionHandler(false);
        }
    }
    private func requestPermission(completionHandler: @escaping (Bool) -> ()) {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
            completionHandler(granted);
            self.sessionQueue.resume()
        }
    }
}
