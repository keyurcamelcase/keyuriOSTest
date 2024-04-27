//
//  BasicStuff.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 26/04/24.
//

import Foundation
import UIKit

struct JSN {
    static var isNetworkConnected:Bool = false
    static func log(_ logMessage: String,_ args:Any... , functionName: String = #function ,file:String = #file,line:Int = #line) {
        
        let newArgs = args.map({arg -> CVarArg in String(describing: arg)})
        let messageFormat = String(format: logMessage, arguments: newArgs)
        
        print("LOG :- \(((file as NSString).lastPathComponent as NSString).deletingPathExtension)--> \(functionName) ,Line:\(line) :", messageFormat)
    }
    static func error(_ logMessage: String,_ args:Any... , functionName: String = #function ,file:String = #file,line:Int = #line) {
        
        let newArgs = args.map({arg -> CVarArg in String(describing: arg)})
        let messageFormat = String(format: logMessage, arguments: newArgs)
        
        print("ERROR :- \(((file as NSString).lastPathComponent as NSString).deletingPathExtension)--> \(functionName) ,Line:\(line) :", messageFormat)
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}


extension UIView {
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}

//MARK: - Shadow Functionality.
extension UIView {
    func shadow(shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    func tabShadow(color:CGColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1).cgColor) {
        let shadowPath0 = UIBezierPath(roundedRect: self.bounds , cornerRadius: 0)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 6
        layer0.shadowOffset = CGSize(width: 0, height: 0)
        layer0.bounds = self.bounds
        layer0.position = self.center
        layer0.backgroundColor = color
        self.layer.addSublayer(layer0)
    }
    
    
    func addShadow(_ color:CGColor = UIColor.lightGray.cgColor) {
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = color
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    func addLightShadow(_ color:CGColor = UIColor.lightGray.cgColor) {
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = color
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    func addTxtShadow(){
        let shadowPath0 = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 6
        layer0.shadowOffset = CGSize(width: 0, height: 0)
        layer0.bounds = self.bounds
        layer0.position = self.center
        self.layer.addSublayer(layer0)
    }
    
    func setShadowView(){
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
        layer.masksToBounds = false
        clipsToBounds = false
        layer.cornerRadius = 50
    }
}

extension UIViewController {
    
    //MARK: Alert
    func showAlert(title: String, message: String? = nil, actionText1: String, actionText2: String? = nil, action1: @escaping (UIAlertAction) -> (), action2: ((UIAlertAction) -> ())? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction1  = UIAlertAction(title: actionText1, style: .default, handler: action1)
        controller.addAction(alertAction1)
        if let action2 = action2 {
            let alertAction2 = UIAlertAction(title: actionText2, style: .cancel, handler: action2)
            controller.addAction(alertAction2)
        }
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}
