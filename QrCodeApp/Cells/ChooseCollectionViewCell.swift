//
//  ChooseCollectionViewCell.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 21.02.2025.
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
    
    let imageview: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup Methods
    func setupViews(){
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageview)
        
        stackView.addArrangedSubview(label)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageview.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
}
