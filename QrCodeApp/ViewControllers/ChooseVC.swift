//
//  ChooseVC.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 21.02.2025.
//

import UIKit
import SnapKit

class ChooseVC: UIViewController {
    
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
    
    private let collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    private let socialCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    private let view2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Social Media"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.clipsToBounds = true
        return label
    }()
    
    //MARK: Properties
    var images2: [UIImage] = [UIImage(named: "mail")!,
                              UIImage(named: "message")!,
                              UIImage(named: "phone")!,
                              UIImage(named: "text")!,
                              UIImage(named: "URL")!]
    var labels: [String] = ["Mail",
                            "Message",
                            "Phone",
                            "Text",
                            "URL"]
    
    var images: [UIImage] = [UIImage(named: "facebook")!,
                             UIImage(named: "youtube")!,
                             UIImage(named: "whatsapp")!,
                             UIImage(named: "twitter")!,
                             UIImage(named: "instagram")!,
                             UIImage(named: "spotify")!]
    var names: [String] = ["facebook",
                           "youtube",
                           "whatsapp",
                           "twitter",
                           "instagram",
                           "spotify"]
    var userId: String = ""
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width - 32,
                                          height: view.frame.height))
        title.text = "Welcome"
        title.font = .boldSystemFont(ofSize: 25)
        title.textColor = .white
        navigationItem.titleView = title
        navigationController?.navigationBar.backgroundColor = UIColor(named: "Color")
        setupViews()
        setupConstraints()
    }

    //MARK: Setup Methods
    func setupViews(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        collectionView2.register(ChooseCollectionViewCell.self,
                                 forCellWithReuseIdentifier: "ChooseCollectionViewCell")
        collectionView2.delegate = self
        collectionView2.dataSource = self
        stackView.addArrangedSubview(collectionView2)
        
        stackView.addArrangedSubview(view2)
        
        view2.addSubview(label)
        
        socialCollectionView.register(SocialCollectionViewCell.self,
                                      forCellWithReuseIdentifier: "SocialCollectionViewCell")
        socialCollectionView.delegate = self
        socialCollectionView.dataSource = self
        stackView.addArrangedSubview(socialCollectionView)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(13)
        }
        stackView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.contentLayoutGuide)
        }
        collectionView2.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(230)
        }
        view2.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(view2).inset(10)
            make.height.equalToSuperview()
        }
        socialCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(230)
        }
    }
}

//MARK: Delegates
extension ChooseVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView2 {
            return images2.count
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseCollectionViewCell",
                                                          for: indexPath) as! ChooseCollectionViewCell
            cell.imageView.image = images2[indexPath.row]
            cell.label.text = labels[indexPath.row]
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialCollectionViewCell",
                                                      for: indexPath) as! SocialCollectionViewCell
        cell.imageview.image = images[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView2 {
            let editVC = EditVC()
            editVC.contentType = labels[indexPath.row]
            editVC.content = labels[indexPath.row]
            editVC.userId = userId
            let nvc = UINavigationController(rootViewController: editVC)
            nvc.modalPresentationStyle = .fullScreen
            nvc.isModalInPresentation = true
            present(nvc, animated: true)
            return
        }else {
            let editVC = EditVC()
            editVC.contentType = names[indexPath.row]
            editVC.content = "Social Media"
            editVC.userId = userId
            let nvc = UINavigationController(rootViewController: editVC)
            nvc.modalPresentationStyle = .fullScreen
            nvc.isModalInPresentation = true
            present(nvc, animated: true)
            return
        }
        
    }
}
