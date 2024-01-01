//
//  LoadingViewManager.swift
//  ShahidAssigment
//
//  Created by Tariq on 25/11/2023.
//

import Foundation
import UIKit

class LoadingViewManager {
    private static var loaderView: UIActivityIndicatorView?
    
    class func showLoader(in viewController: UIViewController) {
        if loaderView == nil {
            loaderView = UIActivityIndicatorView(style: .large)
            loaderView?.center = viewController.view.center
            loaderView?.hidesWhenStopped = true
            viewController.view.addSubview(loaderView!)
        }
        viewController.view.isUserInteractionEnabled = false
        loaderView?.startAnimating()
    }
    
    class func hideLoader(in viewController: UIViewController) {
        loaderView?.stopAnimating()
        viewController.view.isUserInteractionEnabled = true
    }
}
