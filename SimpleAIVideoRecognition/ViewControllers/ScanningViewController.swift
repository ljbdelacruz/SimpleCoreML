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
    // ML - Initialization
    var model: VNCoreMLModel?
    
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "Camera Session Queue", attributes: [], target: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIVideoDisplay.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resize
        self.UIVideoDisplay.session = session
        
        self.checkPermission(completionHandler: {
            (isGranted) in
            if isGranted {
                self.SetupCamera();
                self.loadModel()
            }else{
                print("Sorry Camera not available");
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sessionQueue.async {
            self.session.startRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.sessionQueue.async { [unowned self] in
            self.session.stopRunning()
        }
        super.viewWillDisappear(animated)
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
//MARK: camera setup func
extension ScanningViewController:AVCaptureVideoDataOutputSampleBufferDelegate{
    func SetupCamera(){
        self.session.beginConfiguration()
        self.session.sessionPreset = .hd1280x720
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard self.session.canAddInput(captureDeviceInput) else { return }
        self.session.addInput(captureDeviceInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        guard self.session.canAddOutput(videoOutput) else { return }
        self.session.addOutput(videoOutput)
        self.session.commitConfiguration()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // TODO: Do ML Here
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        self.CheckResult(pixelBuffer: pixelBuffer);
        
    }
}

//MARK: CoreML Func
extension ScanningViewController{
    private func loadModel() {
        model = try? VNCoreMLModel(for: Inceptionv3().model)
    }
    private func CheckResult(pixelBuffer:CVPixelBuffer){
        let request = VNCoreMLRequest(model: model!) {
            (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            DispatchQueue.main.async {
                self.UIItemDescription.text=firstObservation.identifier.components(separatedBy: ",").first;
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
}
