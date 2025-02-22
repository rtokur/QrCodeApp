//
//  LaunchScreen.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 22.02.2025.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth

class LaunchScreen : UIViewController {
    
    let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "splash"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        checkSession()
    }
    
    func setup(){
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func checkSession(){
        //        Task{
        //            let userId = Auth.auth().currentUser?.uid
        //            if userId != nil {
        //
        //            }else {

        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        let tbc = TabBarController()
        
        UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionCrossDissolve) {
            sceneDelegate.window?.rootViewController = tbc
            sceneDelegate.window?.makeKeyAndVisible()
        }
        
    }
}
