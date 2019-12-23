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
    
    lazy var titleInfoField: InfoField = {
        let titleInfoField = InfoField()
        titleInfoField.isUserInteractionEnabled = false
        titleInfoField.text = PlaceHolderText.title
        return titleInfoField
    }()
    
    lazy var messageInfoField: InfoField = {
        let messageInfoField = InfoField()
        messageInfoField.isUserInteractionEnabled = false
        messageInfoField.text = PlaceHolderText.message
        return messageInfoField
    }()
    
    lazy var locationInfoField: InfoField = {
        let locationInfoField = InfoField()
        locationInfoField.isUserInteractionEnabled = false
        locationInfoField.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        locationInfoField.text = PlaceHolderText.location
        return locationInfoField
    }()
    
    lazy var recurringInfoField: InfoField = {
        let recurringInfoField = InfoField()
        recurringInfoField.textAlignment = .center
        recurringInfoField.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        recurringInfoField.isUserInteractionEnabled = false
        recurringInfoField.text = ToggleText.isRepeating
        return recurringInfoField
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
        bubbleColorView.backgroundColor = UIColor(named: Color.bubbleBlue.name)!.withAlphaComponent(0.8)
        bubbleColorView.layer.borderWidth = 3
        bubbleColorView.layer.borderColor = UIColor(named: Color.bubbleBlue.name)?.cgColor
        bubbleColorView.layer.cornerRadius = Constant.activeReminderCellSize/4 // Set later?
        return bubbleColorView
    }()
    
    lazy var arrowImage: UIImageView = {
        let arrowIcon = UIImage(named: Icon.arrowIcon.name)?.withRenderingMode(.alwaysTemplate)
        let arrowImage = UIImageView(image: arrowIcon)
//        arrowImage.transform = CGAffineTransform(rotationAngle: .pi) // Rotated 180 degrees
        arrowImage.transform = CGAffineTransform.identity // Original direction
        arrowImage.tintColor = UIColor(named: .tintColor)
        arrowImage.backgroundColor = .clear
        arrowImage.alpha = 0.8
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
        contentView.addSubview(messageInfoField)
        contentView.addSubview(locationInfoField)
        contentView.addSubview(recurringInfoField)
        contentView.addSubview(bubbleColorView)
        contentView.addSubview(radiusInfoField)
        contentView.addSubview(arrowImage)
                
        NSLayoutConstraint.activate([
            titleInfoField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleInfoField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleInfoField.trailingAnchor.constraint(equalTo: bubbleColorView.leadingAnchor, constant: -Constant.activeReminderOffset),
            titleInfoField.heightAnchor.constraint(equalToConstant: Constant.activeReminderContentHeight),
            
            messageInfoField.topAnchor.constraint(equalTo: titleInfoField.bottomAnchor),
            messageInfoField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageInfoField.trailingAnchor.constraint(equalTo: bubbleColorView.leadingAnchor, constant: -Constant.activeReminderOffset),
            messageInfoField.heightAnchor.constraint(equalToConstant: Constant.activeReminderContentHeight),
            
            locationInfoField.topAnchor.constraint(equalTo: messageInfoField.bottomAnchor),
            locationInfoField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationInfoField.trailingAnchor.constraint(equalTo: bubbleColorView.leadingAnchor, constant: -Constant.activeReminderOffset),
            locationInfoField.heightAnchor.constraint(equalToConstant: Constant.activeReminderContentHeight),
            
            recurringInfoField.topAnchor.constraint(equalTo: contentView.topAnchor),
            recurringInfoField.leadingAnchor.constraint(equalTo: locationInfoField.trailingAnchor),
            recurringInfoField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recurringInfoField.heightAnchor.constraint(equalToConstant: Constant.activeReminderContentHeight),
            
            bubbleColorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.activeReminderOffset),
            bubbleColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.activeReminderOffset),
            bubbleColorView.widthAnchor.constraint(equalToConstant: Constant.activeReminderCellSize/2),
            bubbleColorView.heightAnchor.constraint(equalToConstant: Constant.activeReminderCellSize/2),
            
            radiusInfoField.leadingAnchor.constraint(equalTo: locationInfoField.trailingAnchor),
            radiusInfoField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            radiusInfoField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.textYInset),
            radiusInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/4),
            radiusInfoField.centerXAnchor.constraint(equalTo: bubbleColorView.centerXAnchor),
            
            arrowImage.centerYAnchor.constraint(equalTo: bubbleColorView.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: bubbleColorView.leadingAnchor, constant: Constant.arrowOffset),
            arrowImage.widthAnchor.constraint(equalToConstant: Constant.activeReminderCellSize/4),
            arrowImage.heightAnchor.constraint(equalToConstant: Constant.activeReminderCellSize/4),
        ])
    }
}
