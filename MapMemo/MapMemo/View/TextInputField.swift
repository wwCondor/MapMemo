//
//  TextInputField.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 12/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class TextInputField: UITextField {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constant.largeTextInset, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constant.largeTextInset, dy: 0)
    }
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = Constant.borderWidth
        layer.borderColor = ColorSet.objectColor.cgColor
        backgroundColor = ColorSet.appBackgroundColor
        textColor = ColorSet.tintColor
        font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        textAlignment = .center
        keyboardAppearance = .dark
        returnKeyType = UIReturnKeyType.done
    }
}
