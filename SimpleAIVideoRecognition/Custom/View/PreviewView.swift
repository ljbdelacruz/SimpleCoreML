//
//  PreviewView.swift
//  SimpleAIVideoRecognition
//
//  Created by Lainel John Dela Cruz on 11/11/2018.
//  Copyright © 2018 Lainel John Dela Cruz. All rights reserved.
//


import UIKit
import AVFoundation
class PreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    var session: AVCaptureSession? {
        get{
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }
}

