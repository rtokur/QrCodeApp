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
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Foreground Colors"
        label.textColor = .color
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let foregroundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
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
    var foregroundColors: [UIColor] = [.red,
        .green,
        .blue,
        .yellow,
        .purple,
        .black,
        .brown,
        .gray,
        .orange,
        .magenta]
    
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
        
        imageView.image = generateQRCode(from: url, foregroundColor: .black, backgroundColor: .white)
        stackView.addArrangedSubview(imageView)
        
        stackView.addArrangedSubview(label)
        
        foregroundCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        foregroundCollectionView.delegate = self
        foregroundCollectionView.dataSource = self
        stackView.addArrangedSubview(foregroundCollectionView)
        
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
        label.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        foregroundCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        createNew.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    //MARK: Functions
    func generateQRCode(from string: String, foregroundColor: UIColor, backgroundColor: UIColor) -> UIImage? {
        let data = string.data(using: .utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")

            guard let image = filter.outputImage else {
                return nil
            }
            guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
            colorFilter.setValue(image, forKey: "inputImage")
            colorFilter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
            colorFilter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1")
            guard let coloredImage = colorFilter.outputImage else { return nil }
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = coloredImage.transformed(by: transform)
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
                let tempFile = URL(fileURLWithPath: NSHomeDirectory())
                    .appendingPathComponent("Documents/whatsAppTmp.jpg")
                
                do {
                    try imageData.write(to: tempFile,
                                        options: .atomic)
                    
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

//MARK: Delegates
extension AddVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foregroundColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell",
                                                      for: indexPath) as! ColorCollectionViewCell
        cell.imageView.backgroundColor = foregroundColors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foreGroundColor = foregroundColors[indexPath.row]
        imageView.image = generateQRCode(from: url,
                                         foregroundColor: foreGroundColor,backgroundColor: .white)
    }
    
}
