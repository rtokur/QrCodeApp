//
//  ScanVC.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 21.02.2025.
//

import UIKit
import AVFoundation
import SnapKit

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: Properties
    var session: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //MARK: UI Elements
    let vieww : UIView = {
        let view = UIView()
        return view
    }()
    
    let view2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "DarkGreen3")!.withAlphaComponent(0.5)
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "scan")?.withTintColor(.white)
        return image
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = vieww.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if session?.isRunning == true {
            session?.stopRunning()
        } else {
            DispatchQueue.main.async {
                self.session?.startRunning()
            }
        }
    }
    
    //MARK: Setup Methods
    func setupViews(){
        view.addSubview(vieww)
        session = AVCaptureSession()
        session?.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            guard let input = try? AVCaptureDeviceInput(device: backCamera) else { return }
            
            session?.addInput(input)
            let metadataOutput = AVCaptureMetadataOutput()
            session?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = vieww.bounds
            vieww.layer.addSublayer(videoPreviewLayer!)
            DispatchQueue.main.async {
                self.session?.startRunning()
            }
        }
        view.addSubview(view2)
        view.addSubview(imageView)
        
    }
    
    func setupConstraints(){
        vieww.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        view2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
    }
    
    //MARK: Functions
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session?.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        let url = URL(string: code)!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:])
        }
    }
}
