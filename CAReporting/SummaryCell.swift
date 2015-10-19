//
//  SummaryCell.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var summary: Summary! {
        didSet {
            keyLabel.text = summary.displayString
            dataLabel.text = String(summary.currentVal)
            differenceLabel.text = "\(summary.differenceVal)  (  \(summary.differencePercentage) )"
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
