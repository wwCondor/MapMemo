//
//  CustomButton.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        contentMode = .center
        backgroundColor = ColorSet.objectColor
        tintColor = ColorSet.tintColor
        imageView?.contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func additionalSetup() {
        backgroundColor?.withAlphaComponent(0.9)
    }
}

class AddButton: CustomButton {
    
}

