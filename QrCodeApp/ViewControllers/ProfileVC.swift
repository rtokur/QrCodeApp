//
//  ProfileVC.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 25.02.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

class ProfileVC: UIViewController {

    //MARK: UI Elements
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .color
        label.textAlignment = .center
        return label
    }()
    
    let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .color
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(SignOutBtn), for: .touchUpInside)
        return button
    }()
    
    //MARK: Properties
    var userName: String = ""
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: Setup Methods
    func setupViews(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        nameLabel.text = userName
        stackView.addArrangedSubview(nameLabel)
        
        stackView.addArrangedSubview(signOutButton)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        signOutButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    //MARK: Actions
    @objc func SignOutBtn(_ sender: UIButton){
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure to exit?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "No", style: .cancel)
        let action2 = UIAlertAction(title: "Yes", style: .default) { action in
            do {
                try Auth.auth().signOut()
                let launch = LaunchScreen()
                self.present(launch, animated: true)
            }catch{
                print(error.localizedDescription)
            }
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true)
    }
}
