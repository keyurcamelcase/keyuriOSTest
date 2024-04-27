//
//  HomeScreenDetailsTBVCell.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 26/04/24.
//

import UIKit

class HomeScreenDetailsTBVCell: UITableViewCell {

    @IBOutlet weak var shadowContainView: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.shadowContainView.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
