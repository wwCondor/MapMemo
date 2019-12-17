//
//  ToggleTouchView.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 13/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class TapToggleView: UIView {
    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        backgroundColor = .clear
    }
    
    func viewTapped() {
        toggleView(bool: !isOn)
    }
    
    private func toggleView(bool: Bool) {
        isOn = bool
        print(isOn)
    }
}
