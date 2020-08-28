//
//  ImageViewController.swift
//  FaceTracker
//
//  Created by Isnard Silva on 28/08/20.
//  Copyright © 2020 Isnard Silva. All rights reserved.
//

import UIKit
import Vision

public class ImageViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Properties
    public var image: UIImage?
    
    
    // MARK: - View Lifecycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = image {
            self.imageView.image = img
            self.analyzeImage()
        } else {
            print("No image!")
        }
    }
    
    // MARK: - Private Methods
}


// MARK: - Detect Face
extension ImageViewController {
    private func analyzeImage() {
        // Vision Framework
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceFeatures(request:error:))
        let requestHandler = VNImageRequestHandler(cgImage: image!.cgImage!, options: [:])
        
        do {
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            print(error)
        }
    }
    
    /// Handle face detection results
    private func handleFaceFeatures(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation], observations.count > 0 else {
            print("Did not detect any face!")
            return
        }
        
        print("Did detect \(observations.count) face(s)")
        
        for face in observations {
            self.addFaceLandmarksToImage(face)
        }
    }
    
    /// Draw face landmarks on the screen
    func addFaceLandmarksToImage(_ face: VNFaceObservation) {
        // Check if exist an image
        guard let selectedImage = image else { return }
        
         UIGraphicsBeginImageContextWithOptions(selectedImage.size, true, 0.0)
       // Get current graphic context
       guard let context = UIGraphicsGetCurrentContext() else {
           return
       }

        // draw the image
        selectedImage.draw(in: CGRect(x: 0, y: 0, width: selectedImage.size.width, height: selectedImage.size.height))

        context.translateBy(x: 0, y: selectedImage.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // draw the face rect
        let w = face.boundingBox.size.width * selectedImage.size.width
        let h = face.boundingBox.size.height * selectedImage.size.height
        let x = face.boundingBox.origin.x * selectedImage.size.width
        let y = face.boundingBox.origin.y * selectedImage.size.height
        let faceRect = CGRect(x: x, y: y, width: w, height: h)
        context.saveGState()
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(8.0)
        context.addRect(faceRect)
        context.drawPath(using: .stroke)
        context.restoreGState()

        // face contour
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.faceContour {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // outer lips
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.outerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
//                landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.closePath()
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // inner lips
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.innerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.closePath()
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // left eye
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.closePath()
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // right eye
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.closePath()
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // left pupil
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.closePath()
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // right pupil
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.closePath()
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // left eyebrow
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // right eyebrow
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // nose
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.nose {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.closePath()
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // nose crest
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.noseCrest {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // median line
        context.saveGState()
        context.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.medianLine {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context.setLineWidth(8.0)
        context.drawPath(using: .stroke)
        context.saveGState()

        // get the final image
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()

        // end drawing context
        UIGraphicsEndImageContext()

        imageView.image = finalImage
    }
}

