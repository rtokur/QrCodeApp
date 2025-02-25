//
//  TabBarController.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 21.02.2025.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: UI Elements
    let scanBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Color")
        button.setImage(UIImage(named: "qr-scan"),
                        for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12,
                                       weight: .medium)
        return label
    }()
    
    //MARK: Properties
    var count: Int = 0
    var userId: String = ""
    var userName: String = ""
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        setupMiddleButton()
        setupTabBarItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarItems()
    }
    
    //MARK: Setup Functions
    func setupMiddleButton(){
        scanBtn.frame = CGRect(x: (self.view.bounds.width / 2) - 30,
                               y: -25,
                               width: 60,
                               height: 60)
        scanBtn.addTarget(self,
                          action: #selector(menuButtonAction),
                          for: .touchUpInside)
        
        titleLabel.frame = CGRect(x: scanBtn.frame.origin.x,
                                  y: scanBtn.frame.maxY + 5,
                                  width: scanBtn.frame.width,
                                  height: 20)
        
        self.tabBar.addSubview(scanBtn)
        self.tabBar.addSubview(titleLabel)
        
        self.view.layoutIfNeeded()
    }

    func setupTabBarItems(){
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = UIColor(named: "Color")
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.borderColor = UIColor.color.cgColor
        self.tabBar.layer.borderWidth = 1
        
        let chooseVC = ChooseVC()
        chooseVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus"), tag: 0)
        let cnvc = UINavigationController(rootViewController: chooseVC)
        
        let scanVC = ScanVC()
        let snvc = UINavigationController(rootViewController: scanVC)

        if !userId.isEmpty && !userName.isEmpty {
            let profileVC = ProfileVC()
            profileVC.tabBarItem = UITabBarItem(title: userName, image: UIImage(systemName: "person"), tag: 2)
            profileVC.userName = userName
            let pnvc = UINavigationController(rootViewController: profileVC)
            viewControllers = [cnvc, snvc, pnvc]
        } else {
            let loginVC = LoginVC()
            loginVC.tabBarItem = UITabBarItem(title: "Login", image: UIImage(systemName: "person"), tag: 2)
            let lnvc = UINavigationController(rootViewController: loginVC)
            viewControllers = [cnvc, snvc, lnvc]
        }
        
    }
    
    //MARK: Actions
    @objc func menuButtonAction(sender: UIButton){
        self.selectedIndex = 1
    }
}
