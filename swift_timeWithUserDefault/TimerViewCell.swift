//
//  TimerViewCell.swift
//  swift_timeWithUserDefault
//
//  Created by Yuki Shinohara on 2020/06/05.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class TimerViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
