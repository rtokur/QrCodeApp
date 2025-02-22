//
//  ChooseCollectionViewCell.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 21.02.2025.
//

import UIKit
import SnapKit

class SocialCollectionViewCell: UICollectionViewCell {
    
    //MARK: UI Elements
    let imageview: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        return image
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .color
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup Methods
    func setupViews(){
        contentView.addSubview(imageview)
    }
    
    func setupConstraints(){
        imageview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
}
