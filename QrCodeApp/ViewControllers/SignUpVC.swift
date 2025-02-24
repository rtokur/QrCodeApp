//
//  SignUpVC.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 24.02.2025.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpVC: UIViewController {

    //MARK: Properties
    let db = Firestore.firestore()
    let ref = Storage.storage().reference(withPath: "Profiles")
    
    //MARK: UI Elements
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
        label.text = "REGISTER"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .color
        label.textAlignment = .center
        return label
    }()
    
    private let nameText: UITextField = {
        let text = UITextField()
        text.leftViewMode = .always
        text.borderStyle = .line
        text.backgroundColor = .white
        text.textColor = .black
        return text
    }()
    
    private let emailText: UITextField = {
        let text = UITextField()
        text.leftViewMode = .always
        text.borderStyle = .line
        text.backgroundColor = .white
        text.textColor = .black
        return text
    }()
    
    private let passwordText: UITextField = {
        let text = UITextField()
        text.leftViewMode = .always
        text.borderStyle = .line
        text.backgroundColor = .white
        text.textColor = .black
        return text
    }()
    
    private let signUpBtn: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.backgroundColor = .color
        button.layer.cornerRadius = 10
        button.addTarget(self,
                         action: #selector(SignUpButtonAction(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(DismissVC))
        backButton.tintColor = .color
        navigationItem.leftBarButtonItem = backButton
        setupViews()
        setupConstraints()
        
    }
    
    //MARK: Setup Methods
    func setupViews(){
        let tap = UITapGestureRecognizer(target: view,
                                         action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(label)
        let paddingView3 = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 10,
                                               height: self.nameText.frame.height))
        nameText.leftView = paddingView3
        nameText.attributedPlaceholder = NSAttributedString(string: "Name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        stackView.addArrangedSubview(nameText)
        
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
        
        stackView.addArrangedSubview(signUpBtn)

    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(310)
            make.center.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nameText.snp.makeConstraints { make in
            make.height.equalTo(40)
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
        signUpBtn.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: Actions
    @objc func SignUpButtonAction(_ sender: UIButton){
        Task {
            guard let email = emailText.text, emailText.text != "",
                  let password = passwordText.text, passwordText.text != "",
                  let name = nameText.text, nameText.text != "" else {
                let alert = UIAlertController(title: "Error", message: "Please fill all empty places", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
                    return
                }
            do {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    if let userId = result?.user.uid {
                        Task{
                            self.db.collection("Users").document(userId).setData(["name": name, "email": email] ) { error in
                                guard error == nil else {
                                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                    self.present(alert, animated: true)
                                    return
                                }
                            }
                            let launch = LaunchScreen()
                            launch.isModalInPresentation = true
                            launch.modalPresentationStyle = .fullScreen
                            self.present(launch, animated: true)
                            
                        }
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        
        }
    }
    
    @objc func DismissVC(){
        dismiss(animated: true)
    }

}
