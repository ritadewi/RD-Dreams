//
//  SentMemesCollectionViewCell.swift
//  MemeMe2.0
//
//  Created by Rita Dewi on 14/11/2018.
//  Copyright © 2018 RitaDewi. All rights reserved.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memedImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    func setup(){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 5.0
    }
    
}
