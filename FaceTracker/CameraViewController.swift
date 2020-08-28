//
//  ViewController.swift
//  FaceTracker
//
//  Created by Isnard Silva on 28/08/20.
//  Copyright © 2020 Isnard Silva. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

public class CameraViewController: UIViewController {
    // MARK: - Outlets
    
    
    // MARK: - Properties
    /// Configure input devices (camera), output media, preview views
    /// and basic settings before capturing photos or video
    private let session = AVCaptureSession()
    
    /// Display the camera feed
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var selectedImage: UIImage?
    
    
    // MARK: - View Lifecycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.session.startRunning()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Camera
        self.addCameraInput()
        self.showCameraFeed()
        self.getCameraFrames()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.session.stopRunning()
    }
    
    
    // MARK: - Actions
    @IBAction func openGallery(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageVC = segue.destination as? ImageViewController {
            imageVC.image = self.selectedImage
        }
    }
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // Check if is a valid image
        if let img = info[.originalImage] as? UIImage {
            self.selectedImage = img
            performSegue(withIdentifier: "showImageVC", sender: nil)
        }
    }
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
    
    /// Add an input to the camera session that takes the live camera frames
    private func getCameraFrames() {
        // Indicating that an output will be added to the camera session
        self.session.beginConfiguration()
        
        // Create the video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        // Add the video output to the capture session
        self.session.addOutput(videoOutput)
        
        // Indicating that an output was be added to the camera session
        self.session.commitConfiguration()
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Frame received.")
        
        // Check frames from the camera feed
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("unable to get image from sample buffer")
            return
        }
        
        // Detect face in frame
        self.detectFace(in: frame)
    }
}

// MARK: - Detect Face
extension CameraViewController {
    
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation] {
                    print("Did detect \(results.count) face(s)")
//                    self.handleFaceDetectionResults(results)
                } else {
//                    self.clearDrawings()
                    print("No faces!")
                }
            }
        })
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
    
    // Drawing bounding box faces
    private func handleFaceDetectionResults(_ observedFaces: [VNFaceObservation]) {
        
    }
}
