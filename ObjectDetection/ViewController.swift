//
//  ViewController.swift
//  ObjectDetection
//
//  Created by Skafos.ai on 1/7/19.
//  Copyright © 2019 Skafos, LLC. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Skafos
import CoreML
import Vision
import SnapKit


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
  
  var bufferSize: CGSize = .zero
  var rootLayer: CALayer! = nil

  private lazy var previewView:UIView = {
    let view           = UIView()
    self.view.addSubview(view)
    view.snp.makeConstraints { make in
      make.top.right.left.bottom.equalToSuperview()
    }
    return view
  }()
  
  private let session = AVCaptureSession()
  private var previewLayer: AVCaptureVideoPreviewLayer! = nil
  private let videoDataOutput = AVCaptureVideoDataOutput()
  
  private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // to be implemented in the subclass
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAVCapture()
  }
  
  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if let connection =  self.previewLayer.connection  {
      
      let currentDevice: UIDevice = UIDevice.current
      
      let orientation: UIDeviceOrientation = currentDevice.orientation
      
      let previewLayerConnection : AVCaptureConnection = connection
      
      if previewLayerConnection.isVideoOrientationSupported {
        
        switch (orientation) {
        case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
        
          break
          
        case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
        
          break
          
        case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
        
          break
          
        case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
        
          break
          
        default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
        
          break
        }
      }
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
    
    layer.videoOrientation = orientation
    
    previewLayer.frame = self.view.bounds
    
  }
  
  func setupAVCapture() {
    var deviceInput: AVCaptureDeviceInput!
    
    // Select a video device, make an input
    let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
    do {
      deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
    } catch {
      print("Could not create video device input: \(error)")
      return
    }
    
    session.beginConfiguration()
    session.sessionPreset = .vga640x480 // Model image size is smaller.
    
    // Add a video input
    guard session.canAddInput(deviceInput) else {
      print("Could not add video device input to the session")
      session.commitConfiguration()
      return
    }
    session.addInput(deviceInput)
    if session.canAddOutput(videoDataOutput) {
      session.addOutput(videoDataOutput)
      // Add a video data output
      videoDataOutput.alwaysDiscardsLateVideoFrames = true
      videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
      videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
    } else {
      print("Could not add video data output to the session")
      session.commitConfiguration()
      return
    }
    let captureConnection = videoDataOutput.connection(with: .video)
    // Always process the frames
    captureConnection?.isEnabled = true
    do {
      try  videoDevice!.lockForConfiguration()
      let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
      bufferSize.width = CGFloat(dimensions.width)
      bufferSize.height = CGFloat(dimensions.height)
      videoDevice!.unlockForConfiguration()
    } catch {
      print(error)
    }
    session.commitConfiguration()
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    rootLayer = previewView.layer
    previewLayer.frame = rootLayer.bounds
    rootLayer.addSublayer(previewLayer)
  }
  
  func startCaptureSession() {
    session.startRunning()
  }
  
  // Clean up capture setup
  func teardownAVCapture() {
    previewLayer.removeFromSuperlayer()
    previewLayer = nil
  }
  
  func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // print("frame dropped")
  }
  
  public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
    let curDeviceOrientation = UIDevice.current.orientation
    let exifOrientation: CGImagePropertyOrientation
    
    switch curDeviceOrientation {
    case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
      exifOrientation = .left
    case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
      exifOrientation = .upMirrored
    case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
      exifOrientation = .down
    case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
      exifOrientation = .up
    default:
      exifOrientation = .up
    }
    return exifOrientation
  }
}
