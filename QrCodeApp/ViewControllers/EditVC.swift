//
//  EditVC.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 22.02.2025.
//

import UIKit
import SnapKit

//MARK: Protocole
protocol Increase: AnyObject {
    func increase()
}

class EditVC: UIViewController {

    //MARK: UI Elements
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Your username"
        return label
    }()
    
    private let textField: UITextField = {
        let text = UITextField()
        text.layer.cornerRadius = 10
        text.clipsToBounds = true
        text.font = .boldSystemFont(ofSize: 14)
        text.textColor = .black
        text.addTarget(self,
                       action: #selector(CheckForChanges(_:)),
                       for: .editingChanged)
        return text
    }()
    
    private let createBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.backgroundColor = .color.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self,
                         action: #selector(CreateQR(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: Properties
    weak var delegate: Increase?
    var content: String = ""
    var contentType: String = ""
    var count: Int = 0
    
    //MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                   style: .done,
                                   target: self,
                                   action: #selector(dismissAction(_:)))
        back.tintColor = .white
        navigationItem.leftBarButtonItem = back
        navigationController?.navigationBar.backgroundColor = .color
        setupViews()
        setupConstraints()

    }

    //MARK: Setup Methods
    func setupViews(){
        view.addSubview(stackView)
        
        if content != ""{
            label.text = content
            if content == "Social Media" {
                nameLabel.text = "Your Username"
                textField.attributedPlaceholder = NSAttributedString(string: "@username",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }else if content == "Mail"{
                nameLabel.text = "Email Address"
                textField.attributedPlaceholder = NSAttributedString(string: "email@mail.com",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }else if content == "Message" {
                nameLabel.text = "Your Message"
                textField.attributedPlaceholder = NSAttributedString(string: "Hello",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }else if content == "Phone" {
                nameLabel.text = "Phone Number"
                textField.attributedPlaceholder = NSAttributedString(string: "+90 232 123 45 67",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            } else if content == "Text" {
                nameLabel.text = "Your Text"
                textField.attributedPlaceholder = NSAttributedString(string: "Hello",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }else if content == "URL" {
                nameLabel.text = "Your URL"
                textField.attributedPlaceholder = NSAttributedString(string: "https://www.youtube.com",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }
            
        }
        stackView.addArrangedSubview(label)
        
        stackView.addArrangedSubview(nameLabel)
        
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 10,
                                               height: self.textField.frame.height))
        textField.leftViewMode = .always
        textField.leftView = paddingView
        stackView.addArrangedSubview(textField)
        
        stackView.addArrangedSubview(createBtn)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(13)
        }
        label.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        createBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        
    }
    
    //MARK: Actions
    @objc func dismissAction(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    @objc func CheckForChanges(_ sender: UITextField){
        if sender.text != "" {
            createBtn.isEnabled = true
            createBtn.backgroundColor = .color
        } else {
            createBtn.isEnabled = false
            createBtn.backgroundColor = .color.withAlphaComponent(0.5)
        }
    }
    
    @objc func CreateQR(_ sender: UIButton){
        let addVC = AddVC()
        if content == "Social Media" {
            addVC.url = "https://www.\(contentType).com/\(textField.text)"
        } else {
            addVC.url = textField.text!
        }
        delegate?.increase()
        let nvc = UINavigationController(rootViewController: addVC)
        nvc.isModalInPresentation = true
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
}
