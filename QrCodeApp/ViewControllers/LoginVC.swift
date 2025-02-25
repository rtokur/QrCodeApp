//
//  LoginVC.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 21.02.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginVC: UIViewController {

    //MARK: UI Elements
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.layer.borderColor = UIColor.color.cgColor
        stack.layer.borderWidth = 2
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "LOGIN"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .color
        label.textAlignment = .center
        return label
    }()
    
    private let emailText: UITextField = {
        let text = UITextField()
        text.leftViewMode = .always
        text.borderStyle = .line
        text.backgroundColor = .white
        text.textColor = .black
        text.autocapitalizationType = .none
        text.keyboardType = .emailAddress
        return text
    }()
    
    private let passwordText: UITextField = {
        let text = UITextField()
        text.leftViewMode = .always
        text.borderStyle = .line
        text.backgroundColor = .white
        text.textColor = .black
        text.autocapitalizationType = .none
        text.isSecureTextEntry = true
        return text
    }()
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN IN",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.backgroundColor = .color
        button.layer.cornerRadius = 10
        button.addTarget(self,
                         action: #selector(LoginButtonAction(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private let registerBtn: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .color
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(SignUpAction), for: .touchUpInside)
        return button
    }()
    
    private let vieww: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: Setup Methods
    func setupViews(){
        let tap = UITapGestureRecognizer(target: view,
                                         action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(label)
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 10,
                                               height: self.emailText.frame.height))
        emailText.leftView = paddingView
        emailText.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        stackView.addArrangedSubview(emailText)
        let paddingView2 = UIView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 10,
                                                height: self.passwordText.frame.height))
        passwordText.leftView = paddingView2
        passwordText.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        stackView.addArrangedSubview(passwordText)
        
        stackView.addArrangedSubview(loginBtn)
        
        stackView.addArrangedSubview(registerBtn)
        
        stackView.addArrangedSubview(vieww)

    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        label.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        emailText.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passwordText.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        loginBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        registerBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        vieww.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    //MARK: Actions
    @objc func LoginButtonAction(_ sender: UIButton){
        Task {
            guard let email = emailText.text,
                    let password = passwordText.text else {
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { result, error  in
                guard error == nil else {
                    let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                let launch = LaunchScreen()
                launch.isModalInPresentation = true
                launch.modalPresentationStyle = .fullScreen
                self.present(launch, animated: true)
            }
        }
    }
    
    @objc func SignUpAction(_ sender: UIButton){
        let suvc = SignUpVC()
        let nvc = UINavigationController(rootViewController: suvc)
        nvc.isModalInPresentation = true
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
    
}
