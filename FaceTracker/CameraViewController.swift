//
//  ViewController.swift
//  FaceTracker
//
//  Created by Isnard Silva on 28/08/20.
//  Copyright © 2020 Isnard Silva. All rights reserved.
//

import UIKit
import AVFoundation

public class CameraViewController: UIViewController {
    // MARK: - Outlets
    
    
    // MARK: - Properties
    /// Configure input devices (camera), output media, preview views
    /// and basic settings before capturing photos or video
    private let session = AVCaptureSession()
    
    /// Display the camera feed
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    
    // MARK: - View Lifecycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addCameraInput()
        self.showCameraFeed()
        self.session.startRunning()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.session.stopRunning()
    }
    
    
    // MARK: - Actions
}


// MARK: - Setup Camera
extension CameraViewController {
    /// Add the front camera as an input to our captureSession
    private func addCameraInput() {
        // Indicating that an input will be added to the camera session
        self.session.beginConfiguration()
        
        // Check if the camera is available
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("No front video camera available")
            return
        }
        
        // Connect the camera to the capture session input
        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            self.session.addInput(cameraInput)
        } catch {
            print(error)
        }
        
        // Indicating that an input was be added to the camera session
        self.session.commitConfiguration()
    }
    
    /// Shows what is being displayed by the camera on the app screen
    private func showCameraFeed() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer.frame = self.view.frame
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
    }
}
