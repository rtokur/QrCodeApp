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
import FirebaseFirestore

class LaunchScreen : UIViewController {
    
    //MARK: UI Elements
    let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "splash"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    //MARK: Properties
    let db = Firestore.firestore()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        checkSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Functions
    func setup(){
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func checkSession(){
        Task{
            guard let sceneDelegate = UIApplication.shared
                .connectedScenes
                .first?
                .delegate as? SceneDelegate else { return }
            
            let tbc = TabBarController()
            
            if let userId = Auth.auth().currentUser?.uid {
                tbc.userId = userId
                let name = try await db.collection("Users").document(userId).getDocument()
                guard name.exists else {
                    return
                }
                
                if let name2 = name.data()?["name"] as? String {
                    tbc.userName = name2
                    
                    DispatchQueue.main.async {
                        UIView.transition(with: sceneDelegate.window!,
                                          duration: 0.5,
                                          options: .transitionCrossDissolve) {
                            sceneDelegate.window?.rootViewController = tbc
                            sceneDelegate.window?.makeKeyAndVisible()
                        }
                    }
                }
            }else {
                DispatchQueue.main.async {
                    UIView.transition(with: sceneDelegate.window!,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve) {
                        sceneDelegate.window?.rootViewController = tbc
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
}

