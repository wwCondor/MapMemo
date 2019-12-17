//
//  ReminderCell.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 16/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let inset = Constant.cellPadding
//        let padding = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
//        contentView.frame = contentView.frame.inset(by: padding)
//    }
    
    lazy var titleInfoField: InfoField = {
        let titleInfoField = InfoField()
        titleInfoField.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        titleInfoField.isUserInteractionEnabled = false
        titleInfoField.text = PlaceHolderText.title
        return titleInfoField
    }()
    
    lazy var recurringInfoField: InfoField = {
        let recurringInfoField = InfoField()
        recurringInfoField.textAlignment = .center
        recurringInfoField.isUserInteractionEnabled = false
        recurringInfoField.text = PlaceHolderText.isRepeating
        return recurringInfoField
    }()
    
    lazy var locationInfoField: InfoField = {
        let locationInfoField = InfoField()
        locationInfoField.isUserInteractionEnabled = false
        locationInfoField.text = PlaceHolderText.unknownLocation
        return locationInfoField 
    }()
    
    lazy var radiusInfoField: InfoField = {
        let radiusInfoField = InfoField()
        radiusInfoField.textAlignment = .center
        radiusInfoField.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        radiusInfoField.isUserInteractionEnabled = false
        radiusInfoField.text = PlaceHolderText.defaultRadius
        return radiusInfoField
    }()
    
    lazy var bubbleColorView: UIView = {
        let bubbleColorView = UIView()
        bubbleColorView.translatesAutoresizingMaskIntoConstraints = false
        bubbleColorView.layer.masksToBounds = true
        bubbleColorView.backgroundColor = UIColor(named: Color.bubbleBlue.name)!.withAlphaComponent(0.7)
        bubbleColorView.layer.borderWidth = 3
        bubbleColorView.layer.borderColor = UIColor(named: Color.bubbleBlue.name)?.cgColor
        bubbleColorView.layer.cornerRadius = Constant.inputFieldSize/4 // Set later?
        return bubbleColorView
    }()
    
    lazy var arrowImage: UIImageView = {
        let arrowIcon = UIImage(named: Icon.arrowIcon.name)?.withRenderingMode(.alwaysTemplate)
        let arrowImage = UIImageView(image: arrowIcon)
//        arrowImage.transform = CGAffineTransform(rotationAngle: .pi) // Rotated 180 degrees
        arrowImage.transform = CGAffineTransform.identity // Original direction
        arrowImage.tintColor = ColorSet.tintColor
        arrowImage.backgroundColor = .clear
        arrowImage.alpha = 0.70
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        return arrowImage
    }()
    
    lazy var touchScreen: UIView = {
        let touchScreen = UIView()
        touchScreen.translatesAutoresizingMaskIntoConstraints = false
        touchScreen.backgroundColor = UIColor.clear
        return touchScreen
    }()
    
    func setupViews() {
        contentView.addSubview(titleInfoField)
        contentView.addSubview(recurringInfoField)
        contentView.addSubview(locationInfoField)
        contentView.addSubview(radiusInfoField)
        contentView.addSubview(bubbleColorView)
        contentView.addSubview(arrowImage)
        
        contentView.addSubview(touchScreen)
        
        NSLayoutConstraint.activate([
            titleInfoField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleInfoField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleInfoField.widthAnchor.constraint(equalToConstant: contentView.frame.width/2),
            titleInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            
            recurringInfoField.topAnchor.constraint(equalTo: contentView.topAnchor),
            recurringInfoField.leadingAnchor.constraint(equalTo: titleInfoField.trailingAnchor),
            recurringInfoField.trailingAnchor.constraint(equalTo: locationInfoField.trailingAnchor),
            recurringInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            
            locationInfoField.topAnchor.constraint(equalTo: titleInfoField.bottomAnchor),
            locationInfoField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationInfoField.trailingAnchor.constraint(equalTo: bubbleColorView.leadingAnchor, constant: -Constant.offset),
            locationInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            
            radiusInfoField.leadingAnchor.constraint(equalTo: locationInfoField.trailingAnchor),
            radiusInfoField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            radiusInfoField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            radiusInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/4),
            radiusInfoField.centerXAnchor.constraint(equalTo: bubbleColorView.centerXAnchor),
            
            bubbleColorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.offset),
            bubbleColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.offset),
            bubbleColorView.widthAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            bubbleColorView.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            
            arrowImage.centerYAnchor.constraint(equalTo: bubbleColorView.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: bubbleColorView.leadingAnchor, constant: Constant.arrowAnimationOffset),
            arrowImage.widthAnchor.constraint(equalToConstant: Constant.inputFieldSize/4),
            arrowImage.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/4),
            
            touchScreen.topAnchor.constraint(equalTo: contentView.topAnchor),
            touchScreen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            touchScreen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            touchScreen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {
                        self.arrowImage.center.x += Constant.arrowAnimationOffset
        }, completion: nil)
    }
}
