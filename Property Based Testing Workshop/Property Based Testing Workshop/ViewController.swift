//
//  ViewController.swift
//  Property Based Testing Workshop
//
//  Created by Sebastian Grail on 18/8/18.
//  Copyright © 2018 Sebastian Grail. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        let vm = Person(
            name: "Sebastian Grail",
            description: "iOS developer at Canva",
            avatar: #imageLiteral(resourceName: "avatar"))
        let person = PersonCard(viewModel: vm)
        view.addSubview(person)
        person.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300).priority(.required)
            make.height.equalTo(150).priority(.required)
        }
    }
}

