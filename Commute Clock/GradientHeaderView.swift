//
//  GradientHeaderView.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 3/4/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

class GradientHeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    class func instanceFromNib(title: String) -> GradientHeaderView {
        let nib = UINib(nibName: "GradientHeaderUI", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GradientHeaderView
        nib.titleLabel.text = title
        return nib
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
