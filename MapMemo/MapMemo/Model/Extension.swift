//
//  Extension.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 10/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

extension UIViewController {
    // Hides keyboard when view is tapped
    func hideKeyboardOnBackgroundTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func presentAlert(description: String, viewController: UIViewController) {
        // Alert
        let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert)
        
        let confirmation = UIAlertAction(title: "OK", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmation)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func presentFailedPermissionActionSheet(description: String, viewController: UIViewController) {
        // Actionsheet
        let actionSheet = UIAlertController(title: nil, message: description, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Ok, take me to Settings", style: .default, handler: { (action) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Thanks, but I'll go to settings later", style: .cancel, handler: { (action) in
            
        }))
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}

extension FloatingPoint {
    // Converts to radians. Used for compass image rotation
    var degreesToRadians: Self { return self * .pi / 180 }
}

extension UIImage {
    // Used set alpha on images for mainController
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension String {
    // Convert String to Float
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension String {
    // String to Double
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}

extension LosslessStringConvertible {
    // Double to String
    var toString: String { return .init(self)}
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
