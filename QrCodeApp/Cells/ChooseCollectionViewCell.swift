//
//  ChooseCollectionViewCell2.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 22.02.2025.
//

import UIKit
import SnapKit

class ChooseCollectionViewCell: UICollectionViewCell {
    
    //MARK: UI Elements
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        return image
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
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
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        
        stackView.addArrangedSubview(label)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
