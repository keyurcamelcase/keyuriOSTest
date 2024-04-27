//
//  ViewController.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 26/04/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let homeScreenObj = HomeScreenVC()
            self.navigationController?.setViewControllers([homeScreenObj], animated: true)
        }
    }


}

