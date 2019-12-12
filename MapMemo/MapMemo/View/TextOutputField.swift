//
//  TextOutputField.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 12/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

//import UIKit

// Used UITexttView instead of UILabel for increased flexibility and customisation
//class TextOutPutField: UITextView {
//
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupViews()
//    }
//
//    func setupViews() {
//        translatesAutoresizingMaskIntoConstraints = false
////        addBottomBorder(with: Constant.borderWidth)
//        layer.borderWidth = Constant.borderWidth
//        layer.borderColor = ColorSet.objectColor.cgColor
//        backgroundColor = ColorSet.appBackgroundColor
//        textColor = ColorSet.tintColor
//        font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
//        textAlignment = .center
//        isEditable = false
//        let inset: CGFloat = Constant.smallTextInset
//        textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
//    }
//}

//class ToggleInputField: TextOutPutField {
//    var isOn = false
//
//    @objc private func buttonPressed(sender: ToggleInputField) {
//        activateButton(bool: !isOn)
//    }
//    
//    private func activateButton(bool: Bool) {
//        isOn = bool
//        
////        let text = UIImage(named: Icons.lightModeIcon.image)?.withRenderingMode(.alwaysOriginal)
////        let darkModeIcon = UIImage(named: Icons.darkModeIcon.image)?.withRenderingMode(.alwaysTemplate)
////        let image = bool ? darkModeIcon : lightModeIcon
////        setImage(image, for: .normal)
////
////        let darkModeTint = UIColor.black
////        text = bool ? darkModeTint : nil
//    }
//    
//}
