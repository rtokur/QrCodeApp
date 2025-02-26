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
    var cameraPosition: AVCaptureDevice.Position = .back
    
    //MARK: UI Elements
    let vieww : UIView = {
        let view = UIView()
        return view
    }()
    
    let view2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Color")!
            .withAlphaComponent(0.5)
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "scan")?
            .withTintColor(.white)
        return image
    }()
    
    private let view3 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let swipCameraBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.trianglehead.2.clockwise"),
                        for: .normal)
        button.tintColor = .color
        button.addTarget(self,
                         action: #selector(SwipCamera(_:)),
                         for: .touchUpInside)
        return button
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
        applyMaskView2()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if session?.isRunning == false {
            DispatchQueue.global(qos: .userInitiated).async {
                self.session?.startRunning()
            }
        }
    }
    
    //MARK: Setup Methods
    func setupViews(){
        view.addSubview(vieww)
        session = AVCaptureSession()
        session?.sessionPreset = .high
        setupCamera(position: cameraPosition)
        
        view.addSubview(view2)
        view.addSubview(imageView)
        view.addSubview(view3)
        view3.layer.cornerRadius = 10
        view3.addSubview(swipCameraBtn)
        
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
        view3.snp.makeConstraints { make in
            make.trailing.equalTo(view2).inset(13)
            make.top.equalTo(view2).inset(106)
            make.width.height.equalTo(40)
        }
        swipCameraBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: Functions
    func setupCamera(position: AVCaptureDevice.Position) {
        session?.stopRunning()
        
        session = AVCaptureSession()
        session?.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: position) else {
            return
        }
        
        do {
            guard let input = try? AVCaptureDeviceInput(device: camera) else { return }
            session?.inputs.forEach({ input in
                session?.removeInput(input)
            })
            session?.addInput(input)
            
            let metadataOutput = AVCaptureMetadataOutput()
            session?.outputs.forEach({ output in
                session?.removeOutput(output)
            })
            session?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self,
                                                      queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
            videoPreviewLayer?.removeFromSuperlayer()
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = vieww.bounds
            vieww.layer.addSublayer(videoPreviewLayer!)
            DispatchQueue.global(qos: .userInitiated).async {
                self.session?.startRunning()
            }
        }
    }
    
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
    
    func applyMaskView2(){
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: view2.bounds)
        let holeRect = imageView.frame.insetBy(dx: -20, dy: -20)
        let holePath = UIBezierPath(roundedRect: holeRect, cornerRadius: 20)
        
        path.append(holePath)
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        view2.layer.mask = maskLayer
    }
    
    //MARK: Actions
    @objc func SwipCamera(_ sender: UIButton){
        if cameraPosition == .back {
            cameraPosition = .front
        }else {
            cameraPosition = .back
        }
        setupCamera(position: cameraPosition)
    }
}
