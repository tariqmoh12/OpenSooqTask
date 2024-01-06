//
//  AlertManager.swift
//  ShahidAssigment
//
//  Created by Tariq on 25/11/2023.
//

import UIKit

// MARK: - AlertManager
class AlertManager {
    static func showAlert(in viewController: UIViewController, title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
