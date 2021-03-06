//
//  SummaryCell.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

@objc protocol SummaryCellDelegate {
    optional func summaryCell(summaryCell: SummaryCell)
}


class SummaryCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    
    weak var delegate: SummaryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.masksToBounds = false
        mainView.layer.shadowOffset = CGSizeMake(0, 0)
        mainView.layer.shadowRadius = 2
        mainView.layer.shadowOpacity = 0.3
    }
    
    var summary: Summary! {
        didSet {
            keyLabel.text = summary.displayString
            dataLabel.text = summary.currentValueString
            if summary.differenceVal == nil {
                differenceLabel.hidden = true
            }
            else {
                if(summary.currentVal != nil && summary.currentVal != 0){
                    differenceLabel.text = "\(summary.differenceValueString) (" + String(format: "%.2f", summary.differencePercentage) + "%)"
                }else{
                    differenceLabel.text = "\(summary.differenceValueString)"
                    
                }
                if summary.differenceVal > 0 {
                    differenceLabel.textColor = UIColor(red: 0.42, green: 0.66, blue: 0.31, alpha: 1.0)
                }
                else if summary.differenceVal < 0 {
                    differenceLabel.textColor = UIColor(red: 0.88, green: 0.40, blue: 0.40, alpha: 1.0)
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
