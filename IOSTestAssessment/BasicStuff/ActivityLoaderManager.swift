//
//  ActivityLoaderManager.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 26/04/24.
//

import UIKit

class ActivityLoaderManager {
    
    static let shared = ActivityLoaderManager()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private init() {}
    
    func showLoader() {
        guard let keyWindow = UIApplication.shared.windows.first else {
            return
        }
        
        activityIndicator.center = keyWindow.center
        keyWindow.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}


//MARK: START LOADER
func startLoader(message:String = "") {
    
    //    KRProgressHUD.show()
    ActivityLoaderManager.shared.showLoader()
    //    SVProgressHUD.show()
    //    SVProgressHUD.setForegroundColor(.clear)//(AppColor.theme)
    //    SVProgressHUD.setRingThickness(3)
    //    SVProgressHUD.setBackgroundColor(.clear)//(UIColor.white)
    //    SVProgressHUD.setDefaultMaskType(.clear)//(.black)
}
func startLoaderWithColor() {
    //    UIApplication.shared.beginIgnoringInteractionEvents()
    //    SVProgressHUD.show()
    //    SVProgressHUD.setForegroundColor(Colors.snomo)
    //    SVProgressHUD.setRingThickness(3)
    //    SVProgressHUD.setBackgroundColor(UIColor.white)
    //    SVProgressHUD.setDefaultMaskType(.black)
    //    KRProgressHUD.set(activityIndicatorViewColors: [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
    //    KRProgressHUD.show()
//    customLoaderView.show()
    ActivityLoaderManager.shared.showLoader()
    
    
}



//MARK: STOP LOADER
func stopLoader() {
    //    UIApplication.shared.endIgnoringInteractionEvents()
    //    SVProgressHUD.dismiss()
    //    KRProgressHUD.dismiss()
    ActivityLoaderManager.shared.hideLoader()
}
