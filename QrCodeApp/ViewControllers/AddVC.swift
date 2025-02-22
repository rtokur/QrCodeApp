//
//  ViewController.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 20.02.2025.
//

import UIKit
import SnapKit

class AddVC: UIViewController {

    //MARK: UI Elements
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.backgroundColor = .white
        stackview.spacing = 20
        return stackview
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        return image
    }()
    
    private let vieww: UIView = {
        let view = UIView()
        return view
    }()
    
    private let shareBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"),
                        for: .normal)
        button.tintColor = .color
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self,
                         action: #selector(ShareAction(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private let createNew: UIButton = {
        let button = UIButton()
        button.setTitle("Create New QR Code", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .color
        button.addTarget(self,
                         action: #selector(createNew(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: Properties
    var controller: UIDocumentInteractionController?
    var url: String = ""
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                      style: .done,
                                      target: self,
                                      action: #selector(dismissVC))
        backBtn.tintColor = .white
        navigationItem.leftBarButtonItem = backBtn
        navigationController?.navigationBar.backgroundColor = .color
    }
    
    //MARK: Setup Methods
    func setupViews(){
        let tap = UITapGestureRecognizer(target: view,
                                         action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(vieww)
        vieww.addSubview(shareBtn)
        scrollView.addSubview(stackView)
        
        imageView.image = generateQRCode(from: url)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(createNew)

    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(13)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        vieww.snp.makeConstraints { make in
            make.top.trailing.equalTo(imageView).inset(5)
            make.width.height.equalTo(40)
        }
        shareBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        createNew.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    //MARK: Functions
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii,
                               allowLossyConversion: false)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let image = filter.outputImage!
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = image.transformed(by: transform)
            let img = UIImage(ciImage: scaledImage)
            return img
        }
        return nil
    }
    
    //MARK: Actions
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    @objc func createNew(_ sender: UIButton){
        let tbc = TabBarController()
        tbc.isModalInPresentation = true
        tbc.modalPresentationStyle = .fullScreen
        present(tbc, animated: true)
    }
    
    @objc func ShareAction(_ sender: UIButton) {
        if let image = imageView.image {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.jpg")
                
                do {
                    try imageData.write(to: tempFile, options: .atomic)
                    
                    controller = UIDocumentInteractionController(url: tempFile)
                    controller?.uti = "public.jpeg"
                    controller?.presentOpenInMenu(from: sender.frame,
                                                  in: self.view,
                                                  animated: true)
                    
                } catch {
                    print("Dosya yazılamadı: \(error)")
                }
            }
        }
    }

}

