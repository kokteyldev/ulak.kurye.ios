//
//  ScannerVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 17.03.2022.
//

import UIKit
import AVFoundation

protocol ScannerDelegate: AnyObject {
    func didScanCode(code: String)
    func didFailScan(errorMessage: String)
}

final class ScannerVC: BaseVC {
    @IBOutlet weak var videoView: UIView!
    
    weak var delegate: ScannerDelegate?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPreview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Override
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.title = "scan_qr_code".localized
        view.backgroundColor = UIColor.black
    }
    
    private func setupPreview() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    // MARK: - Actions
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Scanner
    private func failed() {
        captureSession = nil
        self.dismiss(animated: true) {
            self.delegate?.didFailScan(errorMessage: "scan_not_supported_error".localized)
        }
    }
    
    private func found(code: String) {
        captureSession = nil
        self.dismiss(animated: true) {
            self.delegate?.didScanCode(code: code)
        }
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}
