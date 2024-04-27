//
//  CommentDetailsTBVCell.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 27/04/24.
//

import UIKit

class CommentDetailsTBVCell: UITableViewCell {
    @IBOutlet weak var shadowMainCOntainView: UIView!
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.shadowMainCOntainView.addLightShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
