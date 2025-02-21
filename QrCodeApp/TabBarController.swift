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
        button.backgroundColor = UIColor(named: "DarkGreen2")
        button.setImage(UIImage(named: "qr-scan"), for: .normal)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DarkGreen")
        self.delegate = self
        setupMiddleButton()
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
        self.tabBar.tintColor = UIColor(named: "DarkGreen3")
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        
        let chooseVC = ChooseVC()
        chooseVC.tabBarItem = UITabBarItem(title: "Add",
                                        image: UIImage(systemName: "plus"),
                                        tag: 0)
        let cnvc = UINavigationController(rootViewController: chooseVC)
        
        let scanVC = ScanVC()
        let snvc = UINavigationController(rootViewController: scanVC)

        let loginVC = LoginVC()
        loginVC.tabBarItem = UITabBarItem(title: "Login",
                                          image: UIImage(named: "circle-user"),
                                          tag: 1)
        let lnvc = UINavigationController(rootViewController: loginVC)
        
        self.viewControllers = [cnvc, snvc, lnvc]
    }
    
    //MARK: Actions
    @objc func menuButtonAction(sender: UIButton){
        self.selectedIndex = 1
        self.titleLabel.textColor = UIColor(named: "DarkGreen3")
    }
}
