//
//  TextInputField.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 12/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        additionalSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        additionalSettings()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ColorSet.appBackgroundColor
        textColor = ColorSet.tintColor
        keyboardAppearance = .dark
        returnKeyType = UIReturnKeyType.done
    }
    
    func additionalSettings() {
        textAlignment = .center
        layer.borderWidth = Constant.borderWidth
        layer.borderColor = ColorSet.objectColor.cgColor
        font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    }
}

class InfoField: CustomTextField {
    override func additionalSettings() {
        textAlignment = .left
        // These are used for postioning
        layer.borderWidth = Constant.borderWidth // MARK: Delete
        layer.borderColor = UIColor.yellow.cgColor // MARK: Delete
        font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constant.largeTextInset, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constant.largeTextInset, dy: 0)
    }
}
