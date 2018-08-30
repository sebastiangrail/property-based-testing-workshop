//
//  Person.swift
//  Property Based Testing Workshop
//
//  Created by Sebastian Grail on 24/8/18.
//  Copyright © 2018 Sebastian Grail. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public struct Person {
    var name: String
    var description: String
    var avatar: UIImage
}


/// A card view for `Person`
/// Property based testing can help us find the bugs (the commented out lines)
public class PersonCard: UIView {
    public init(viewModel: Person) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.backgroundColor = .white
        
        let avatarView = UIImageView(image: viewModel.avatar)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = viewModel.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = viewModel.description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        
        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(avatarView).offset(5).priority(ConstraintPriority.low)
        }
        
        let imageSize: CGFloat = 50
        avatarView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(5)
            make.width.height.equalTo(imageSize).priority(ConstraintPriority.required)
//            make.bottom.lessThanOrEqualTo(self.snp.bottom).inset(5)
        }
        avatarView.layer.cornerRadius = imageSize/2
        avatarView.layer.masksToBounds = true
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).priority(.required)
            make.leading.equalTo(avatarView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5).priority(.required)
            make.leading.equalTo(nameLabel)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
//            make.trailing.equalToSuperview().inset(5)
//            make.bottom.lessThanOrEqualTo(self.snp.bottom).inset(5).priority(.low)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
