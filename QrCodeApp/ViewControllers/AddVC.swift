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
        return stackview
    }()
    
    private let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        return image
    }()
    
    private let textField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter your website"
        text.font = .boldSystemFont(ofSize: 25)
        text.textColor = .black
        text.attributedPlaceholder = NSAttributedString(string: "Enter your website", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        text.addTarget(self, action: #selector(textFieldEditing(_:)), for: .editingChanged)
        return text
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Setup Methods
    func setupViews(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        imageView.image = generateQRCode(from: "")
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(stackView2)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.textField.frame
            .height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        stackView.addArrangedSubview(textField)

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
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii, allowLossyConversion: false)
        
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
    @objc func textFieldEditing(_ sender: UITextField) {
        let text = sender.text!
        guard text != "" else {
            imageView.image = generateQRCode(from: "")
            return
        }
        if let image = generateQRCode(from: text) {
            imageView.image = image.withRenderingMode(.alwaysOriginal)
        }
    }
    
}

